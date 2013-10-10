ifeq ($(PACKAGE_SET),vm)
WIN_SOURCE_SUBDIRS := .
SOURCE_COPY_IN := copy-components
endif

copy-components:
	mkdir -p $(CHROOT_DIR)/$(DIST_SRC)/components
	cp $(SRC_DIR)/*/*.msm $(CHROOT_DIR)/$(DIST_SRC)/components/
