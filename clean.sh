#!/bin/sh

cd micropython
make clean
cd -

rm -rf ./build
rm -rf ./.cache
rm -rf ./__pycache__
