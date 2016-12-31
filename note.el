;;; note.el my customized emacs function
;;
;;



;;;###autoload
(defun sync-push ()
  "call sync push function, push the changes to github"
  (interactive)
  (let (cmdStr)
    (setq cmdStr "/Users/jingweigu/Documents/note/sync.sh push")
    (shell-command cmdStr)
    )
  )

;;;###autoload
(defun sync-pull ()
  "call sync push function, push the changes to github"
  (interactive)
  (let (cmdStr)
    (setq cmdStr "/Users/jingweigu/Documents/note/sync.sh pull")
    (shell-command cmdStr)
    )
  )



(provide 'note)

;;; note.el ends here 
