OUTDIR:=./.out
ARTIFACT_NAME:=mypios.img

EXAMPLES := $(wildcard config/*.example.toml)
CONFIGS  := $(patsubst config/%.example.toml,config/%.toml,$(EXAMPLES))

.PHONY: setup-config

.init-output:
	mkdir -p ${OUTDIR}

.guard-%:
	@ if [ "${${*}}" = "" ]; then \
	    echo "Environment variable $* not set"; \
		exit 1; \
	fi

setup-pathing:
	sed -i 's|/home/jack/dev/nix-pi-base|$(shell pwd)|g' flake.nix

setup-config: $(CONFIGS)

config/%.toml: config/%.example.toml
	cp $< $@

.decompress-build: .init-output
	unzstd result/sd-image/nixos-image-sd-card-*-aarch64-linux.img.zst -o ${OUTDIR}/${ARTIFACT_NAME}

build:
	nix build --impure .#packages.aarch64-linux.sdcard --system aarch64-linux

safe-eject: .guard-DEVICE
	sync
	sudo eject ${DEVICE}

flash: .guard-DEVICE .decompress-build
	sudo dd if=${OUTDIR}/${ARTIFACT_NAME} of=${DEVICE} bs=8M status=progress conv=fsync
