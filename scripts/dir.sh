#!/usr/bin/env bash -x

# frequently used dir maninpulation functions.

# create dir using current date as name, e.g `2019-11-11`.
function mkdir_today() {
  mkdir -p $(date '+%Y-%m-%d')
}

# create dir using current date as name, e.g `19-11-11`.
function mkdir_today_short() {
  mkdir -p $(date '+%y-%m-%d')
}
