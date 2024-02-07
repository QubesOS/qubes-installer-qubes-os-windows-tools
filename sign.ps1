# recursively sign all {*.exe | *.dll | *.sys | *.cat } files in a directory with a newly generated test certificate
# usage: $0 [directory]
# if directory is not specified, uses <script dir>\bin

if ($env:EWDK_PATH -eq $null) {
    Write-Error "EWDK_PATH variable not set"
    exit 1
}

if ($env:Version_Number -eq $null) {
    Write-Error "EWDK environment not initialized"
    exit 1
}

$bins = "$PSScriptRoot\bin"
if ($args[0] -ne $null) {
    $bins = $args[0]
}

$cert_path = "$PSScriptRoot\testsign.cer" # TODO: allow changing this

# do nothing if the cert exists (signing requires a complete rebuild since the cert is ephemeral)
if (Test-Path $cert_path) {
    Write-Warning "$cert_path already exists, skipping sign"
    # TODO: fail if binaries are not signed (incomplete previous build)
    exit 0
}

$cn = "Invisible Things Lab"
$ts_url = "http://timestamp.digicert.com"
$end_date = (Get-Date).AddYears(5)

$cert = New-SelfSignedCertificate -KeyUsage DigitalSignature -KeySpec Signature -Type CodeSigningCert -HashAlgorithm sha256 -CertStoreLocation "Cert:\CurrentUser\My" -Subject $cn -NotAfter $end_date
$tp = $cert.Thumbprint

Export-Certificate -Cert $cert -FilePath $cert_path
$sha1 = (Get-FileHash $cert_path -Algorithm SHA1).Hash

$signtool = "$env:EWDK_PATH\Program Files\Windows Kits\10\bin\$env:Version_Number\x64\signtool.exe"

if (! (Test-Path $signtool)) {
    Write-Error "$signtool not found"
    break
}

foreach ($file in (dir "$bins" -Include ('*.exe', '*.dll', '*.sys', '*.cat') -Recurse)) {
    Start-Process -FilePath $signtool -Wait -NoNewWindow -ArgumentList "sign /sha1 $sha1 /fd sha256 /td sha256 /tr $ts_url $file"
}

# remove the cert from the build machine
Remove-Item "cert:\CurrentUser\My\$tp"

# signtool adds it to the user's CA store so remove from there as well
Remove-Item "cert:\CurrentUser\CA\$tp"
