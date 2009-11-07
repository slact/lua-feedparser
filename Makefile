PREFIX = /usr/local
# System's lua directory (where Lua libraries are installed)
LUA_DIR= $(PREFIX)/share/lua/5.1

NAME=feedparser
VERSION=0.7
all:
	@echo "nothing to make"
	@echo "run make install, please. don't forget make test, too"

test:
	lua tests/XMLElement.lua
	lua tests/dateparser.lua
	lua tests/feedparser.lua

install:
	install feedparser.lua $(LUA_DIR)/
	mkdir -p $(LUA_DIR)/feedparser
	install feedparser/* $(LUA_DIR)/feedparser
	
bundle:
	tar --create --verbose --exclude-vcs --gzip --file=../$(NAME)-$(VERSION).tar.gz ../$(NAME)
