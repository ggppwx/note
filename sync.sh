#!/bin/bash
clear
timestamp=$(date +"%m-%d-%y_%H:%M")
echo "auto-commit@ $timestamp"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
cd $DIR
git add -u
git commit -m "auto-commit@ $timestamp"
git push origin master

