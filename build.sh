#!/bin/sh

set -e

if [ "$(uname -s)" = 'Darwin' ]; then
    echo Building on macOS, setting up paths...
    if [ "$(uname -p)" = 'arm' ]; then
        echo Apple Silicon detected...
        export CMAKE_INCLUDE_PATH=/opt/homebrew/opt/flex/include
        export CMAKE_LIBRARY_PATH=/opt/homebrew/opt/flex/lib
        export PATH="/opt/homebrew/opt/flex/bin:/opt/homebrew/opt/bison/bin:$PATH"
    else
        echo x86_64 detected...
        export CMAKE_INCLUDE_PATH=/usr/local/opt/flex/include
        export CMAKE_LIBRARY_PATH=/usr/local/opt/flex/lib
        export PATH="/usr/local/opt/flex/bin:/usr/local/opt/bison/bin:$PATH"
    fi
fi

mkdir -p build/
cd build/ || exit
cmake ..
make
make test
