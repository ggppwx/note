#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export GIT_SSL_NO_VERIFY=1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOSTNAME=$(hostname)
echo $DIR


function git-pull
{
    echo "git pull ......"
    cd $DIR
    # git stash
    git pull origin master -X theirs
}

#export GIT_SSL_NO_VERIFY=1
function git-push-force
{
    echo "git push file $*"
    cd $DIR
    for file in  "$@"
    do
	
	git add "$file"
    done
    git commit -m "force push file $*"
    git push origin master -f     
}


function git-autopush
{
    timestamp=$(date +"%m-%d-%y_%H:%M")
    echo "git autopush ....."
    echo "----------- auto-commit@ $timestamp --------------"    
    cd $DIR    
    git add -u
    git commit -m "auto-commit@ $timestamp from $HOSTNAME"
    git pull origin master 
    git push origin master
}

function create-summary
{
    bash $DIR/emacsBatch.sh > $DIR/agenda.csv
}


# schedule run
function schedule
{
    counter=0
    while true
    do
	if [ $counter = 10 ]; then
	    git-pull
	    counter=0
	else
	    create-summary
	    sleep 5
	    git-push-force "agenda.html" "agenda"
	    git-autopush
	fi
	sleep 5000    
    done
}



if [[ "$#" = "0" ]] ; then
    echo "no argument! bring up a process"
    schedule    
    exit
elif [[ "$#" = "1" ]]; then
    echo $1
    if [[ $1 = "pull" ]]; then
        git-pull
    fi
    if [[ $1 = "push" ]]; then
	create-summary
	sleep 5
	git-push-force "agenda.csv" "exercise.csv" "pomodora.csv"
        git-autopush
    fi
    if [[ $1 = "summary" ]]; then
	create-summary
    fi
    
    exit
else
    echo "argument number ERROR"
fi






