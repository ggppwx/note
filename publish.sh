#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

TIMESTAMP=`date +%Y-%m-%d`

# create new file name 

# convert it to html/md

# copy to a cerntain directory
DES="/home/jgu4/Desktop/"

function git_push
{
    cd $DES
    git add $1
    git commit -m "updating $1"
    git pull
    git push
}


# git-push to sync
if [[ $# != "1" ]] ;then
    echo "ERROR...."
else
    OLD_FILE_NAME=$1
    echo "processing $OLD_FILE_NAME..."
		 
    NEED_CONVERT=true
    
    if [[ $OLD_FILE_NAME = *.org ]]; then
	# org to html
	TEMP_FILE_NAME="${OLD_FILE_NAME%.org}.html"
	NEW_FILE_NAME="$TIMESTAMP-$TEMP_FILE_NAME"    
	echo $NEW_FILE_NAME

    elif [[ $OLD_FILE_NAME = *.md ]]; then
	# directly copy
	NEED_CONVERT=false
	TEMP_FILE_NAME="$OLD_FILE_NAME"
	NEW_FILE_NAME="$TIMESTAMP-$TEMP_FILE_NAME"    
	echo $NEW_FILE_NAME	
    else
	echo "ERROR: $OLD_FILE_NAME is not the right format"
	exit
    fi
    
    # new file in dir ?
    MATCH=$(find $DES -maxdepth 1 -name "*$TEMP_FILE_NAME")
    echo $MATCH

    if [[ $MATCH = "" ]]; then
	NEW_FILE_PATH="$DES$NEW_FILE_NAME"
	echo "NOT MATCH.. creaating new: $NEW_FILE_NAME"
    else
	echo "MATCH.. update"
	NEW_FILE_PATH="$MATCH"
	echo $NEW_FILE_PATH
    fi

    # convert
    if [[ $NEED_CONVERT = true ]]; then
	echo "converting via pandoc"
	pandoc $OLD_FILE_NAME -o $NEW_FILE_PATH
    else
	echo "direct copy..."
	cp $OLD_FILE_NAME $NEW_FILE_PATH
    fi
    
    # git commit
    git_push $NEW_FILE_NAME

fi
