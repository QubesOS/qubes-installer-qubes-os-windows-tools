$disk1 = Get-Disk -Number 1
$match = ($disk1.FriendlyName -eq 'XENSRC PVDISK')
$match = $match -or ($disk1.FriendlyName -eq 'QEMU HARDDISK')
$match = $match -and $disk1.PartitionStyle -eq 'RAW'
if ($match) {
    Initialize-Disk -Number 1
    New-Volume -DiskNumber 1 -DriveLetter Q -FriendlyName 'Qubes Private Image'
}
