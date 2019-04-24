#!/bin/bash

dartfmt ./ -w

git add .
git commit -m "$1"
git push
