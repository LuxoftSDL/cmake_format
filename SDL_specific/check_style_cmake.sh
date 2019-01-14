#!/usr/bin/env bash

#
# Current script is a bit modified version of check_style.sh from sdl_core.
# But the logic is completely the same, except we cannot exclude the whole 3rd_party directory
# from found Cmake files.
#


FORMATER=cmake-format
INSTALL_CMD="pip install -f $FORMATER"

if [ "$1" = "--help" ]
then
    echo ""
    echo "Script checks CMake code style in all CMakeLists.txt and .cmake files"
    echo "Uses $FORMATER as base tool. Install it with : $INSTALL_CMD"
    echo "Usage: `basename $0` [option]"
    echo "      --fix   Fix files format indirectly"
    echo "      --help  Display this information"
    exit 0
fi

command -v $FORMATER >/dev/null 2>&1 || { echo >&2 "$FORMATER is not installed. Use following: $INSTALL_CMD"; exit 1; }

DIRS_TO_EXCLUDE=(build \
  apache-log4cxx-0.10.0 \
  apr-1.5.0 \
  apr-util-1.5.3 \
  expat-2.1.0 \
  gmock-1.7.0)
DIRS_TO_EXCLUDE_STR=$(IFS='|'; echo "${DIRS_TO_EXCLUDE[*]}")

FILE_NAMES=$(find . -name \*.cmake -type f -print -o -name CMakeLists\* -type f -print | grep -Ev $DIRS_TO_EXCLUDE_STR)

# cmake-format will try to find configuration file by checking recursively
#   parent directories of file to be formated.
check_style() {
  $FORMATER $1 | diff $1 -
}

fix_style() {
  $FORMATER -i $1
}

if [ "$1" = "--fix" ]; then
  for FILE_NAME in $FILE_NAMES; do
    fix_style $FILE_NAME;
  done
else
  PASSED=0
  for FILE_NAME in $FILE_NAMES; do
    echo "$FILE_NAME"
    check_style $FILE_NAME
    if [ $? != 0 ]; then
      echo "in " $FILE_NAME
      PASSED=1
    fi
  done
  exit $PASSED
fi
