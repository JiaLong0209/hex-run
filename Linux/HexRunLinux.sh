#!/bin/sh
echo -ne '\033c\033]0;HexRun\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/HexRunLinux.x86_64" "$@"
