#!/bin/sh

wget https://dist.libuv.org/dist/v1.19.1/libuv-v1.19.1.tar.gz

tar xf libuv-v1.19.1.tar.gz

cd libuv-v1.19.1

sh autogen.sh

./configure

make

make install