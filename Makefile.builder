NO_ARCHIVE = 1
ifeq ($(PACKAGE_SET),dom0)
RPM_SPEC_FILES := rpm_spec/win-iso.spec
WINDOWS_IMAGE_EXTRACT_EXTRA := components-versions rel
endif
ifeq ($(PACKAGE_SET),vm)
WIN_COMPILER := msbuild
WIN_BUILD_CMD := true
WIN_SOURCE_SUBDIRS := .
WIN_SLN_DIR := vs2017
SOURCE_COPY_IN := copy-components
SOURCE_COPY_OUT := copy-versions-out
WIN_PREBUILD_CMD = set_version.bat && powershell -executionpolicy bypass -File set_version.ps1 < nul
WIN_PACKAGE_EXT := msi
WIN_POSTBUILD_CMD := del advertise-tools.exe && call $(WINDOWS_SCRIPTS)/sign.bat
WIN_BUILD_DEPS := vmm-xen-windows-pvdrivers core-vchan-xen core-qubesdb windows-utils core-agent-windows gui-common gui-agent-windows
WIN_OUTPUT_BIN := bin
WIN_CROSS_POSTBUILD_CMD := rm -f advertise-tools.exe
endif

copy-components:
	mkdir -p $(CHROOT_DIR)/$(DIST_SRC)/components
	cp $(SRC_DIR)/*/*.msm $(CHROOT_DIR)/$(DIST_SRC)/components/
	cp $(SRC_DIR)/*/windows/*.msm $(CHROOT_DIR)/$(DIST_SRC)/components/
	mkdir -p $(CHROOT_DIR)/$(DIST_SRC)/new-versions
	for c in $(WIN_BUILD_DEPS); do \
		cp $(SRC_DIR)/$$c/version \
			$(CHROOT_DIR)/$(DIST_SRC)/new-versions/version-$$c 2>/dev/null; \
	done
	if ! diff -qr $(CHROOT_DIR)/$(DIST_SRC)/components-versions \
	              $(CHROOT_DIR)/$(DIST_SRC)/new-versions; then \
		echo $$[ `cat $(ORIG_SRC)/rel` + 1 ] > $(CHROOT_DIR)/$(DIST_SRC)/rel; \
	fi

	cp $(BUILDER_REPO_DIR)/core-agent-windows/lib/advertise-tools.exe $(CHROOT_DIR)/$(DIST_SRC)

copy-versions-out:
	@echo "    components-versions"
	@rm -fr $(ORIG_SRC)/components-versions
	@cp -r $(CHROOT_DIR)/$(DIST_SRC)/new-versions $(ORIG_SRC)/components-versions
	@echo "    rel"
	@cp --remove-destination $(CHROOT_DIR)/$(DIST_SRC)/rel $(ORIG_SRC)/
