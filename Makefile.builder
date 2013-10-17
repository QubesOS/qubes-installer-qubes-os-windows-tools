ifeq ($(PACKAGE_SET),dom0)
RPM_SPEC_FILES := rpm_spec/win-iso.spec
WINDOWS_IMAGE_EXTRACT_EXTRA := components-versions build
endif
ifeq ($(PACKAGE_SET),vm)
WIN_SOURCE_SUBDIRS := .
SOURCE_COPY_IN := copy-components
SOURCE_COPY_OUT := copy-versions-out
endif

copy-components:
	mkdir -p $(CHROOT_DIR)/$(DIST_SRC)/components
	cp $(SRC_DIR)/*/*.msm $(CHROOT_DIR)/$(DIST_SRC)/components/
	mkdir -p $(CHROOT_DIR)/$(DIST_SRC)/new-versions
	for c in $(COMPONENTS); do \
		cp $(SRC_DIR)/$$c/version \
			$(CHROOT_DIR)/$(DIST_SRC)/new-versions/version-$$c 2>/dev/null; \
	done
	if ! diff -qr $(CHROOT_DIR)/$(DIST_SRC)/components-versions \
	              $(CHROOT_DIR)/$(DIST_SRC)/new-versions; then \
		echo $$[ `cat $(ORIG_SRC)/build` + 1 ] > $(CHROOT_DIR)/$(DIST_SRC)/build; \
	fi

copy-versions-out:
	@echo "    components-versions"
	@rm -fr $(ORIG_SRC)/components-versions
	@cp -r $(CHROOT_DIR)/$(DIST_SRC)/new-versions $(ORIG_SRC)/components-versions
	@echo "    build"
	@cp --remove-destination $(CHROOT_DIR)/$(DIST_SRC)/build $(ORIG_SRC)/
