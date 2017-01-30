;;; pomodora.el module for time tracking  
(require 'alert)
(setq debug-on-error t)


(defvar org-pomodora-current-work)
(defvar org-pomodora-timer0)
(defvar org-pomodora-timer1)
(defvar org-pomodora-timer2)
(defvar org-pomodora-timer3)
(defvar org-pomodora-timer4)
(defvar org-pomodora-timer5)
(defvar org-pomodora-timer6)

(when (eq system-type 'gnu/linux) 
  (setq alert-default-style 'libnotify)
  (setq alert-fade-time 40)
  )

(when (eq system-type 'darwin) 
  (setq alert-default-style 'osx-notifier)
  (setq alert-fade-time 40)
  )


(defcustom pomodora-path "/Users/jingweigu/Documents/note/pomodora.org"
  "set the note directory"
  :type 'string
  :group 'pomodora
  )



(defcustom pomodora-sound-file "./alarm.wav"
  "sound file location"
  :type 'string
  :group 'pomodora
 )

(defcustom pomodora-work-period 25
  "set work period"
  :type 'integer
  :group 'pomodora
  )

(defcustom pomodora-break-period 10
  "set break period"
  :type 'integer
  :group 'pomodora
  )


(defun trim-string (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
  (replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string))
)

(defun lock-screen ()
  (when (eq system-type 'gnu/linux) 
    (shell-command "gnome-screensaver-command -l")
    )
  )

(defun org-pomo-in ()
    (show-alert "start working !!" )
  )

;; one pomodora complete, set the status 
(defun org-pomo-out ()
  (show-alert "time to break !!" )
  ;; add complete sign
  (let ( ( heading (nth 0 org-pomodora-current-work)) (timestamp (nth 1 org-pomodora-current-work)) )
    (message "org-pomo-out: %s on %s" heading timestamp)
    (org-pomodora heading timestamp "[X]")
    )
  (play-sound pomodora-sound-file)
  (lock-screen)
  )

(defun org-pomo-complete ()
  (show-alert "pomodora complete, take a long break" )
  (let ( ( heading (nth 0 org-pomodora-current-work)) (timestamp (nth 1 org-pomodora-current-work)) )
    (message "org-pomo-out: %s on %s" heading timestamp)
    (org-pomodora heading timestamp "[X]")
    )
  (setq  org-pomodora-current-work '(nil , nil))
  (play-sound pomodora-sound-file)
  (lock-screen)
  )

(defun show-alert (info)
  (alert info :title "pomodora warning" :severity 'high)
  )


(defun play-sound (file)
  (let (cmdStr)
    (setq cmdStr (concat "play " file))
    (call-process-shell-command cmdStr nil 0)
    )  
  )

;;;###autoload
(defun org-pomo-current-work ()
  (interactive)
  (message "%s  at: %s" (nth 0 org-pomodora-current-work)  (nth 1 org-pomodora-current-work))
  )


;;;###autoload
(defun org-start-pomodora ()
  " start the pomodora time tracking  "
  (interactive)
  ;; record the task name 2
  (setq heading (org-get-heading))
  (setq timestamp (format-time-string "%Y-%m-%d"))
  (message "start work: %s on %s" heading timestamp)
  (setq  org-pomodora-current-work `(,heading ,timestamp))

  (setq current-period 0)
  (setq  org-pomodora-timer0 (run-at-time "3 sec" nil  #'org-pomo-in))
  ;; work  25
  (setq current-period (+ current-period pomodora-work-period ))
  (setq  org-pomodora-timer1 (run-at-time (format "%d min"  current-period ) nil  #'org-pomo-out))
  ;; break 10
  (setq current-period (+ current-period pomodora-break-period ))
  (setq  org-pomodora-timer2 (run-at-time  (format "%d min"  current-period )  nil  #'org-pomo-in))
  ;; work 25
  (setq current-period (+ current-period pomodora-work-period ))
  (setq  org-pomodora-timer (run-at-time  (format "%d min"  current-period ) nil  #'org-pomo-out))
  ;; break 10
  (setq current-period (+ current-period pomodora-break-period ))
  (setq  org-pomodora-timer3 (run-at-time  (format "%d min"  current-period ) nil  #'org-pomo-in))
  ;; work 25
  (setq current-period (+ current-period pomodora-work-period ))
  (setq  org-pomodora-timer4 (run-at-time  (format "%d min"  current-period ) nil  #'org-pomo-out))
  ;; break 10
  (setq current-period (+ current-period pomodora-break-period ))
  (setq  org-pomodora-timer5 (run-at-time  (format "%d min"  current-period ) nil  #'org-pomo-in))
  ;; work 25 complete
  (setq current-period (+ current-period pomodora-work-period ))
  (setq  org-pomodora-timer6 (run-at-time  (format "%d min"  current-period )  nil  #'org-pomo-complete))
  )

;;;###autoload
(defun org-stop-pomodora ()
  " stop the pomodora time tracking  "
  (interactive)
  (message "stop all pomodora timer")
  (cancel-timer org-pomodora-timer0)
  (cancel-timer org-pomodora-timer1)
  (cancel-timer org-pomodora-timer2)
  (cancel-timer org-pomodora-timer3)
  (cancel-timer org-pomodora-timer4)
  (cancel-timer org-pomodora-timer5)
  (cancel-timer org-pomodora-timer6)
  (setq  org-pomodora-current-work '(nil , nil))
  )


;; util function 
(defun org-pomodora (heading timestamp marks)
  (when (and heading  timestamp)  
    (find-file pomodora-path)  
    ;; go to table
    (goto-char (point-min))
    (search-forward "#+NAME: pomodora")
    (setq table-start-pos (+ (line-end-position ) 1))
    (goto-char table-start-pos) ;; start of the table 
    
    (setq table-end-pos ( - (re-search-forward "^\s*$") 1))

    (save-excursion
      (goto-char table-end-pos)
      (beginning-of-line)
      (forward-char 1)
      (setq table-end-line (org-table-current-dline))
      )
    
    
    (setq found nil)
    (save-excursion
      (org-table-goto-line 2)
      ;;(forward-char 1)
      (setq currentline 2)
      (while ( <= currentline table-end-line)
	(message "a line %d" currentline)
	(let (( date (trim-string (org-table-get-field 1)))
	      (content  (trim-string (org-table-get-field 2)))
	      (status (trim-string (org-table-get-field 3)))
	      )
	  (message "%s - %s" date content)
	  
	  ;; if heading == content && date == datestamp
	  ;; modify the status
	  (save-excursion
	    (when (and (string= date timestamp) (string= content heading))
	      (org-table-put currentline 3 (concat status marks))
	      (setq found t)
	    )
	    )
	  )
	
	;; go to next line
	(setq currentline (+ currentline 1 ))
	(org-table-goto-line currentline)
	)
      )
        
    ;; if nothing found, create a new entry
    ( when (eq found nil)
      (goto-char table-start-pos)  
      (re-search-forward "^\s*$") 
      (insert "|"  timestamp "|" heading "|" marks "|" "\n")
      )
    
    (org-table-align)

    (save-buffer)        
    )  
  )


;;;###autoload
(defun org-pomodora-test ()
  (interactive)
  (setq heading (org-get-heading))
  (setq timestamp (format-time-string "%Y-%m-%d"))
  (message "start work: %s on %s" heading timestamp)
  (setq  org-pomodora-current-work `(,heading ,timestamp))
  (message "out at: %s" (nth 1 org-pomodora-current-work))
  (save-excursion
    (find-file pomodora-path)
    )
  )


;;;###autoload
(defun org-pomodora-test-out ()
  (interactive)
  (setq  org-pomodora-timer (run-at-time "1 sec" nil  #'show-alert "hello world"))
  ;; (cancel-timer org-pomodora-timer)
  )
