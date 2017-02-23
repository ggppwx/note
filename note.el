;;; note.el my customized emacs function
;;
;;

(defcustom note-dir '/Users/jingweigu/Documents/note/'
  "set the note directory"
  :type '(string)
  :group 'note
  )

(defcustom note-sync-push-timer 6
  "set the sync push timer (hour)"
  :type 'number
  :group 'note
  )

(defcustom note-checkout-time "07pm"
  "set the checkout time"
  :type 'string
  :group 'note
  )



(defvar sync-timer)

;;;###autoload
(defun sync-push-in-buffer ()
  "call sync push function, push the changes to github in buffer"
  (interactive)
  (let (cmdStr)
    (setq cmdStr (concat note-dir "sync.sh push &"))
    (shell-command cmdStr)
    )
  )


;;;###autoload
(defun sync-push ()
  "call sync push function, push the changes to github"
  (interactive)
  (let (cmdStr)
    (setq cmdStr (concat note-dir "sync.sh push &"))
    (export-exercise)
    (export-pomodora)
    (call-process-shell-command cmdStr nil 0)
    (message "sync-push done")
    )
  )





;;;###autoload
(defun sync-overwrite-pull ()
  "call sync pull function, use theirs"
  (interactive)
  (let (cmdStr)    
    (setq cmdStr (concat note-dir "sync.sh pull &"))
    (call-process-shell-command cmdStr nil 0)
    (message "sync-pull done")
    )
  )

;;;###autoload
(defun sync-start-day ()
  "start a day"
  (interactive)
  (setq sync-timer (run-at-time note-checkout-time nil  'sync-push ))
  (message "check out at %s" note-checkout-time)
  )




;;;###autoload
(defun sync-timer-start ()
  "start the sync timer"
  (interactive)
  (setq sync-timer (run-at-time note-checkout-time (* 60 60 note-sync-push-timer)  'sync-push ))
  (message "start sync timer")
  )


;;;###autoload
(defun sync-timer-stop ()
  "stop the sync timer"
  (interactive)
  (cancel-timer sync-timer)
  )

;;;###autoload
(defun export-table-in-org (name)
  "Search for table named `NAME` and export."
  (goto-char (point-min))
  (let ((case-fold-search t))
    (if (search-forward-regexp (concat "#\\+NAME: +" name) nil t)
	(progn 
	  (message "yes")      
	  (forward-line)
	  (org-table-export (format "csv/%s.csv" name) "orgtbl-to-csv"))
      (message "no"))))


(defun export-table-in-org-file (path name)
  (with-current-buffer (find-file-noselect path) ;;; this makes function run in backgroud
    (export-table-in-org name))
  )

;;;###autoload
(defun export-exercise ()
  (interactive)
  (export-table-in-org-file (concat note-dir "/" "workout.org") "exercise")  
  )


;;;###autoload
(defun export-pomodora ()
  (interactive)
  (export-table-in-org-file (concat note-dir "/" "pomodora.org") "pomodora")  
  )




;; go through all todos in id list
;; save them to a csv file
;; id, heading, date




;;;###autoload
(defun my-org-get-date ()
  (interactive)
  (with-current-buffer (find-file-noselect (concat note-dir "/" "org.org"))
    (org-find-entry-with-id "jsdp")
    (my-org-entry-get-subtree "jsdp")
    )
  )

(defun my-org-entry-get-subtree (id)
  (interactive)
  (save-excursion
    (save-restriction
      (org-narrow-to-subtree)
      (goto-char (point-max))
      (save-match-data
        (cl-loop while (re-search-backward (format "State.*\\(%s\\)" (org-re-timestamp 'inactive)) nil t)
                 ;;collect (org-entry-get (point) property)
		 do (message "%s , %s" id (match-string 1))
		 )))))



(provide 'note)

;;; note.el ends here 
