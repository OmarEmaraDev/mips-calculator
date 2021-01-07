# MIPS Calculator

A simple calculator written in MIPS. A college assignment.

The program can be executed on three different platforms.

## Linux

### Source

The source for this platform is available in `main.s`. It is written for
the N64 ABI of MIPS in the GNU Assembler syntax.

### Dependencies

The following programs need to be available in `PATH`:

- `qemu-mips64el`.

The GCC Cross Compiler Toolchain for the MIPS N64 Little Endian target
and the MIPS musl Libc library are also needed as a dependency, but they
will be automatically downloaded the first time the program is build.

### Build

To build the program, execute:

```
make
```

### Run

To build and run the program, execute:

```
make run
```

### Documentation

The following [article][article] describes the process of writing, compiling,
and running MIPS binaries on Linux.

## MARS

### Source

The source for this platform is available in `mainMARS.s`. It is written
for the 32 bit version of MIPS in the MARS syntax. Moreover, it uses the
syscall provided by MARS.

### Dependencies

The following programs need to be available in `PATH`:

- `mars-mips`.

### Run

To run the program, execute:

```
make runMARS
```

## SPIM

### Source

The source for this platform is generated automatically from the MARS
source at run-time by passing the MARS source through a preprocesssor.

### Dependencies

The following programs need to be available in `PATH`:

- `spim`.

The [`mars-preprocessor`][marsPreprocessor] program is also needed as
a dependency, but it will be automatically downloaded the first time
the program is run.

### Run

To run the program, execute:

```
make runSPIM
```

[article]: https://dev.to/omaremaradev/guide-to-writing-compiling-and-running-mips-binaries-on-linux-55n1
[marsPreprocessor]: https://github.com/OmarEmaraDev/mars-preprocessor
