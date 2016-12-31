;;; note.el my customized emacs function


(defun sync-push ()
  (interactive)
  (let (cmdStr)
    (setq cmdStr "/Users/jingweigu/Documents/note/sync.sh push")
    (shell-command cmdStr)
    )
  )
