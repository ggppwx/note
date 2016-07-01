#!/bin/bash
clear
timestamp=$(date +"%m-%d-%y_%H:%M")
echo "----------- auto-commit@ $timestamp --------------"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR


function git-pull
{
    echo "git pull ......"
    cd $DIR
    git stash
    git pull origin master
    exit
}

#export GIT_SSL_NO_VERIFY=1
function git-autopush
{
    echo "git autopush ....."
    cd $DIR
    git add -u
    git commit -m "auto-commit@ $timestamp"
    echo "ready to push"
    git push origin master
    exit
}


if [[ "$#" != "1" ]] ; then
    echo "should have 1 argument !"
    exit
else
    echo $1
    if [[ $1 = "pull" ]]; then
        git-pull
    fi
    if [[ $1 = "push" ]]; then
        git-autopush
    fi    
    exit
fi






