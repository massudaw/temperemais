#!/bin/sh
stack exec site clean 
git submodule update 
cd _site && git pull origin gh-pages && cd - 
stack exec site watch

