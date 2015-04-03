PREFIX = /usr/local
# System's lua directory (where Lua libraries are installed)
LUA_DIR= $(PREFIX)/share/lua/5.2
LUA_BIN= lua

NAME=feedparser
VERSION=0.71
all:
	@echo "nothing to make"
	@echo "run make install, please. don't forget make test, too"

test:
	${LUA_BIN} tests/XMLElement.lua
	${LUA_BIN} tests/dateparser.lua
	${LUA_BIN} tests/feedparser.lua

install:
	install feedparser.lua $(LUA_DIR)/
	mkdir -p $(LUA_DIR)/feedparser
	install feedparser/* $(LUA_DIR)/feedparser

bundle:
	tar --create --verbose --exclude-vcs --gzip --file=../$(NAME)-$(VERSION).tar.gz ../$(NAME)
