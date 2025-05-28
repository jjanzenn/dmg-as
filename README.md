# dmg-as

This is a Game Boy assembler.

## Build instructions

Ensure you have installed dependencies:

- `cmake`
- `bison`
- `flex`

Note that `flex` and `bison` must be installed through Homebrew on macOS for the build script to work.

Get the code:
```sh
git clone --recurse-submodules https://git.jjanzen.ca/jjanzen/dmg-as.git
cd dmg-as
```

Build the project with the provided  build script.
```sh
./build.sh
```

The program can then be found in the `build/` directory as `dmg-as`.
