DISPLAY_BOLD  := "\033[01m"
DISPLAY_RESET := "\033[0;0m"


VERSION       := $(shell echo `git describe --first-parent --long --match=v* --dirty 2> /dev/null || echo v0.0`)


build:
	docker build -t g-hel:${VERSION} .
	docker tag g-hel:${VERSION} g-hel:latest

test: build
	docker run g-hel

dev: build
	docker run -it --rm -v `pwd`:/src g-hel bash

export: build
	docker rm g-hel.${VERSION} || :
	docker create --name g-hel.${VERSION} g-hel:${VERSION} /bin/true
	docker export g-hel.${VERSION} | gzip > g-hel.${VERSION}.tar.gz

version:
	@echo ${VERSION}
