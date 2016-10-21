#!/bin/bash


AGENDA=$(emacs -batch -l ~/.emacs -eval '(org-batch-agenda "a")')
echo "$AGENDA" 




# TODO=$(emacs -batch -l ~/.emacs -eval '(org-batch-agenda-csv "t")')
# echo "$TODO" 
