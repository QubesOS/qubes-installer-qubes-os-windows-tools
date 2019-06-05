OUTDIR = bin/$(ARCH)
CFLAGS += -DUNICODE -municode -std=c11 -fgnu89-inline -D_WIN32_WINNT=0x0600
LDFLAGS += -ladvapi32

all: $(OUTDIR) $(OUTDIR)/uninstaller.exe

$(OUTDIR):
	mkdir -p $@

$(OUTDIR)/uninstaller.exe: uninstaller/uninstaller.c
	$(CC) $^ $(CFLAGS) $(LDFLAGS) -o $@
