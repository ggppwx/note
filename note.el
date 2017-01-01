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
    (shell-command cmdStr)
    )
  )

;;;###autoload
(defun sync-pull ()
  "call sync pull function, use theirs"
  (interactive)
  (let (cmdStr)    
    (setq cmdStr (concat note-dir "sync.sh pull &"))
    (shell-command cmdStr)
    )
  )


;;;###autoload
(defun sync-timer-start ()
  "start the sync time"
  (interactive)
  (setq sync-timer (run-at-time "5 sec" nil  #'sync-push ))
  )


(provide 'note)

;;; note.el ends here 
