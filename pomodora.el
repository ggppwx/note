;;; pomodora.el module for time tracking  


;;;###autoload
(defun start-pomodora ()
  " start the pomodora time tracking  "
  (interactive)
  (setq ret (run-at-time "10 sec" nil  #'message "break" ))
  (setq ret (run-at-time "5 sec" nil  #'message "back to work again" ))
  )
