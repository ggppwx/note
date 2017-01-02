;;; note.el my customized emacs function
;;
;;

(defcustom note-dir '/Users/jingweigu/Documents/note/'
  "set the note directory"
  :type '(string)
  :group 'note
  )

(defvar sync-timer)

;;;###autoload
(defun sync-push ()
  "call sync push function, push the changes to github"
  (interactive)
  (let (cmdStr)
    (setq cmdStr (concat note-dir "sync.sh push &"))
    (call-process-shell-command cmdStr nil 0)
    )
  )

;;;###autoload
(defun sync-pull ()
  "call sync pull function, use theirs"
  (interactive)
  (let (cmdStr)    
    (setq cmdStr (concat note-dir "sync.sh pull &"))
    (call-process-shell-command cmdStr nil 0)
    )
  )


;;;###autoload
(defun sync-timer-start ()
  "start the sync timer"
  (interactive)
  (setq sync-timer (run-at-time "5 sec" (* 60 60 6)  'sync-push ))
  )


;;;###autoload
(defun sync-timer-stop ()
  "stop the sync timer"
  (interactive)
  (cancel-timer sync-timer)
  )


(provide 'note)

;;; note.el ends here 
