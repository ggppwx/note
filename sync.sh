#!/bin/bash
timestamp=$(date +"%m-%d-%y_%H:%M")
echo "----------- auto-commit@ $timestamp --------------"
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export GIT_SSL_NO_VERIFY=1

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






