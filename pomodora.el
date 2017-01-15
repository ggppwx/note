;;; pomodora.el module for time tracking  
(require 'alert)

(when (eq system-type 'gnu/linux) 
  (setq alert-default-style 'libnotify)
  (setq alert-fade-time 10)
  )

(defun org-pomo-in ()
    (show-alert "start working !!" )
  )


(defun org-pomo-out ()
    (show-alert "time to break !!" )
  )


(defun show-alert (info)
  (alert info :title "pomodora warning" :severity 'high)
  )

;;;###autoload
(defun org-start-pomodora ()
  " start the pomodora time tracking  "
  (interactive)
  (setq ret (run-at-time "3 sec" nil  #'org-pomo-in)
  ;; work  25
  (setq ret (run-at-time "25 min" nil  #'org-pomo-out)
  ;; break 10
  (setq ret (run-at-time "30 min" nil  #'org-pomo-in)
  ;; work 25
  (setq ret (run-at-time "55 min" nil  #'org-pomo-out)
  ;; break 10
  (setq ret (run-at-time "65 min" nil  #'org-pomo-in)
  ;; work 25
  (setq ret (run-at-time "90 min" nil  #'org-pomo-out)
  ;; break 10
  (setq ret (run-at-time "100 min" nil  #'org-pomo-in)
  ;; work 25 complete
  (setq ret (run-at-time "125 min" nil  #'org-pomo-out)
  )




;;;###autoload
(defun org-pomodora ()
  (interactive)
  (org-clock-in)
  )
