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
    (call-process-shell-command cmdStr nil 0)
    (message "sync-push done")
    )
  )





;;;###autoload
(defun sync-pull ()
  "call sync pull function, use theirs"
  (interactive)
  (let (cmdStr)    
    (setq cmdStr (concat note-dir "sync.sh pull &"))
    (call-process-shell-command cmdStr nil 0)
    (message "sync-pull done")
    )
  )


;;;###autoload
(defun sync-timer-start ()
  "start the sync timer"
  (interactive)
  (setq sync-timer (run-at-time "07pm" (* 60 60 note-sync-push-timer)  'sync-push ))
  (message "start sync timer")
  )


;;;###autoload
(defun sync-timer-stop ()
  "stop the sync timer"
  (interactive)
  (cancel-timer sync-timer)
  )


(provide 'note)

;;; note.el ends here 
