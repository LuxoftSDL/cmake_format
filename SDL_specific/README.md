# SDL Specific

## Purpose

 This directory contains files to be added to sdl_core to make it work with
 cmake-format properly.

## Detailed description

 * .cmake-format.json - is a configuration file for cmake-format. The sense is completely the same as for `.clang-format` configuration file. cmkae-format tool without `--config` key will try to find configuration file checking recursively parent directories in respect to the file to be formatted. Once the file is found, overwritten options will be taken into account.

 The very basic check whether the configuration right looks as follows:

 ```
 $ cmake-format --dump-config json
 ```
 This command will dump current configuration to the `stdout` in the format of `json`. Available formats are: `json`, `yaml`, `py`.

 Note: Please, take into account, the custom configuration file is not required to contain the full configuration and it should be placed the same or one of parent directories in order to be taken into account.

 * check_style_cmake.sh - simple bash script which based on `check_style.sh` from sdl_core. This script looks for `CMakeLists` and `*.cmake` files and checks their styling.

## Notes

1) The changes in develop branch break the unit tests of current projects.
2) Mostly the changes break default configuration which can be simply overwritten with a configuration file.
3) Recursive parsing of `cmake` files is not required while tool works as well as clang-format.
4) bash regex in lexer.py is not complete since what if I use simply `sh`?