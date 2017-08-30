#!/bin/bash

mkdir -p docs-xml
mkdir -p docs-html

function generate() {
    echo "Generating $1 ..."
    haxe -D "PLUSTD_TARGET=$1" -D "PLUSTD_OS=$3" -D PLUSTD_QUIET \
        --macro "sk.thenet.M.makeDocTypes()" -lib plustd -D doc-gen \
        --macro "include('sk.thenet')" \
        --no-output -xml "docs-xml/$1.xml" "-$2" dummy || exit 1
}

generate flash swf
generate js.canvas js
generate neko neko
generate cppsdl.desktop cpp osx

haxelib run dox -in "^sk\.thenet" -i docs-xml -o docs-html
