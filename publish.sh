#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

TIMESTAMP=`date +%Y-%m-%d`

# create new file name 

# convert it to html/md

# copy to a cerntain directory
DES="/Users/jingweigu/Documents/workspace/ggppwx.github.io/_posts/"

function git_push
{
    cd $DES
    git add $NEW_FILE_NAME
    git commit -m "updating $OLD_FILE_NAME"
    git pull
    git push
}


# git-push to sync
if [[ $# != "1" ]] ;then
    echo "ERROR...."
else
    OLD_FILE_NAME=$1

    

    # org to html 
    TEMP_FILE_NAME="${OLD_FILE_NAME%.org}.html"
    NEW_FILE_NAME="$TIMESTAMP-$TEMP_FILE_NAME"    
    echo $NEW_FILE_NAME

    # new file in dir ?
    MATCH=$(find $DES -name "*$TEMP_FILE_NAME")
    echo $MATCH

    if [[ $MATCH = "" ]]; then
	NEW_FILE_PATH="$DES$NEW_FILE_NAME"
	echo "NOT MATCH.. run convertion: $NEW_FILE_NAME"
    else
	echo "MATCH.. update"
	NEW_FILE_PATH="$MATCH"
	echo $NEW_FILE_PATH
    fi


    
    # convert 
    pandoc $OLD_FILE_NAME -o $NEW_FILE_PATH

    # git commit
    git_push $NEW_FILE_NAME

fi
