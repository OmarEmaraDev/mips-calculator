CC := ./build/mips64el-linux-musl-cross/bin/mips64el-linux-musl-gcc
LDFLAGS := -static

MARS_PREPROCESSOR_URL := https://raw.githubusercontent.com/OmarEmaraDev/mars-preprocessor/master/mars-preprocessor.py
MUSL_CC_URL := https://musl.cc/mips64el-linux-musl-cross.tgz

.PHONY: all
all: build/calculator

build/mips64el-linux-musl-cross.tgz:
	curl -o build/mips64el-linux-musl-cross.tgz $(MUSL_CC_URL)

build/mips64el-linux-musl-cross: build/mips64el-linux-musl-cross.tgz
	tar -xvzf build/mips64el-linux-musl-cross.tgz -C build/
	touch build/mips64el-linux-musl-cross

build/calculator: main.s build/mips64el-linux-musl-cross
	$(CC) $(LDFLAGS) -o build/calculator main.s

.PHONY: run
run: build/calculator
	qemu-mips64el build/calculator

.PHONY: runMARS
runMARS: mainMARS.s
	mars-mips nc sm mainMARS.s

build/mars-preprocessor.py:
	curl -o build/mars-preprocessor.py $(MARS_PREPROCESSOR_URL)

build/mainSPIM.s: mainMARS.s build/mars-preprocessor.py
	python build/mars-preprocessor.py -i mainMARS.s -o build/mainSPIM.s

.PHONY: runSPIM
runSPIM: build/mainSPIM.s
	spim -file build/mainSPIM.s

.PHONY: clean
clean:
	rm -rf build

