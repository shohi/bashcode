#!/user/bin/env bash

# https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
function traverse_folder() {
  local dir=$PWD
  for file in "${dir}"/*; do
    if [ -d "$file" ]; then
      continue
    elif [ ! -f "$file" ]; then
      continue
    fi

    qfilename=$(basename $file)
    filename="${qfilename%.*}"
    extension="${qfilename##*.}"

    printf "file path => ${file}\n"
    printf "base name => ${qfilename}\n"
    printf "file name => ${filename}\n"
    printf "file ext => ${extension}\n\n\n"

  done
}
