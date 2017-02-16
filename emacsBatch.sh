#!/bin/bash


AGENDA=$(emacs -batch -l ~/.emacs -eval '(org-batch-agenda-csv "n")')
echo "$AGENDA" 

# emacs -eval '(org-batch-store-agenda-views)' -kill
emacs -l ~/.emacs \
-eval '(progn (org-batch-store-agenda-views))' --batch


# emacs -eval '(org-batch-store-agenda-views)' -kill
#TODO=$(emacs -batch -l ~/.emacs -eval '(org-batch-agenda-csv "t")')
#echo "$TODO" 
