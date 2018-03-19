FLUTTER = flutter

VERSION := $(shell cat VERSION)
SOURCES := $(wildcard lib/*.dart)

all: build

.built: $(SOURCES)
	$(FLUTTER) build apk
	@touch $@

build: .built

check:
	$(FLUTTER) test

dist: .built
	@echo "not implemented" && false # TODO

install: .built
	$(FLUTTER) install

uninstall:
	@echo "not implemented" && false # TODO

clean:
	@rm -f .built *~
	$(FLUTTER) clean

distclean: clean

mostlyclean: clean

screenshot:
	$(FLUTTER) screenshot

.PHONY: check dist install uninstall clean distclean mostlyclean
.PHONY: screenshot
.SECONDARY:
.SUFFIXES:
