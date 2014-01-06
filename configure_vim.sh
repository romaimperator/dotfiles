#!/bin/bash
set -e

./configure --enable-rubyinterp \
  --enable-perlinterp \
  --enable-pythoninterp \
  --enable-multibyte \
  --with-features=huge \
  --prefix=/usr/local

