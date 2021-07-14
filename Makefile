.PHONY: run valor default clean plugins

VALOR_VER ?= 0.5.2-beta.0
PLUGINS_FILE?=plugins.json
PLUGINS=$(shell cat $(PLUGINS_FILE) | jq -r '.plugins[] | .name')
OUT_DIR?=out
NATIVE_PLUGINS_PATTERN=${OUT_DIR}/plugins/${LIB_PRE}%${LIB_EXT}
NATIVE_PLUGINS=$(PLUGINS:%=${NATIVE_PLUGINS_PATTERN})
VALOR_GIT=https://github.com/valibre-org/valor.git

UNAME:=$(shell uname -s)
ifeq ($(UNAME), Darwin)
	LIB_PRE=lib
	LIB_EXT=.dylib
endif
ifeq ($(UNAME), Linux)
	LIB_PRE=lib
	LIB_EXT=.so
endif

default: valor plugins

run: valor plugins
	LD_LIBRARY_PATH=$(OUT_DIR)/plugins $(OUT_DIR)/$< -p plugins.json

plugins: $(NATIVE_PLUGINS)

valor: $(OUT_DIR)/valor

clean: 
	rm -f $(OUT_DIR)/valor
	rm -f $(NATIVE_PLUGINS) 

target/release/$(LIB_PRE)%$(LIB_EXT):
	cargo build -p $* --release

$(OUT_DIR)/valor:
	#cargo install -f valor_bin --version $(VALOR_VER) --target-dir target
	cargo install -f --target-dir target --root $(OUT_DIR) --git $(VALOR_GIT) --branch main valor_bin
	@mkdir -p $(@D);
	#cp `which valor_bin` $@

$(NATIVE_PLUGINS_PATTERN): target/release/$(LIB_PRE)%$(LIB_EXT)
	@mkdir -p $(@D)
	mv $< $@ 
	strip $@
