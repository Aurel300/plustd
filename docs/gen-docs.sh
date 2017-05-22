#!/bin/bash

mkdir -p docs-xml
mkdir -p docs-html

echo "Generating flash ..."
haxe -cp ../package/src/ -D doc-gen --macro "include('sk.thenet')" --no-output \
    -D PLUSTD_TARGET=flash -xml docs-xml/flash.xml -swf dummy.swf || exit 1
echo "Generating js.canvas ..."
haxe -cp ../package/src/ -D doc-gen --macro "include('sk.thenet')" --no-output \
    -D PLUSTD_TARGET=js.canvas -xml docs-xml/js.xml -js dummy.js || exit 1
echo "Generating neko ..."
haxe -cp ../package/src/ -D doc-gen --macro "include('sk.thenet')" --no-output \
    -D PLUSTD_TARGET=neko -xml docs-xml/neko.xml -neko dummy.n || exit 1
echo "Generating cppsdl.desktop ..."
haxe -cp ../package/src/ -D doc-gen --macro "include('sk.thenet')" --no-output \
    -D PLUSTD_TARGET=cppsdl.desktop -D PLUSTD_OS=osx -xml docs-xml/cpp.xml \
    -cpp dummy.cpp || exit 1
haxelib run dox -in "^sk\.thenet" -i docs-xml -o docs-html
