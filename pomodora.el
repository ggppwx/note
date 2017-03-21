;;; pomodora.el module for time tracking  
(require 'alert)
(setq debug-on-error t)


(defvar org-pomodora-current-work nil)
(defvar org-pomodora-timer0 nil)
(defvar org-pomodora-timer1 nil)
(defvar org-pomodora-timer2 nil)
(defvar org-pomodora-timer3 nil)
(defvar org-pomodora-timer4 nil)
(defvar org-pomodora-timer5 nil)
(defvar org-pomodora-timer6 nil)
(defvar org-pomodora-timer7 nil)
(defvar org-pomodora-start-time nil)

(when (eq system-type 'gnu/linux) 
  (setq alert-default-style 'libnotify)
  (setq alert-fade-time 40)
  )

(when (eq system-type 'darwin) 
  (setq alert-default-style 'osx-notifier)
  (setq alert-fade-time 40)
  )

(when (eq system-type 'cygwin) 
  (setq alert-default-style 'message)
  (setq alert-fade-time 40)
  )


(defcustom pomodora-path "/Users/jingweigu/Documents/note/pomodora.org"
  "set the note directory"
  :type '(string)
  :group 'pomodora
  )



(defcustom pomodora-sound-file "./alarm.wav"
  "sound file location"
  :type '(string)
  :group 'pomodora
 )

(defcustom pomodora-work-period 25
  "set work period"
  :type '(integer)
  :group 'pomodora
  )

(defcustom pomodora-break-period 10
  "set break period"
  :type '(integer)
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
  (when (eq system-type 'darwin) 
    (shell-command "/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend")
    )
  (when (eq system-type 'cygwin) 
    (shell-command "rundll32.exe user32.dll,LockWorkStation")
    )
  )

(defun org-pomo-in ()
  (show-alert "start working !!" )
  (when (not org-pomodora-start-time)
    (setq org-pomodora-start-time (current-time))
    )  
  )

;; one pomodora complete, set the status 
(defun org-pomo-out ()
  (show-alert "time to break !!" )

  (when org-pomodora-start-time
    (setq org-pomodora-start-time nil)
    )  

  ;; add complete sign
  (let ( ( heading (nth 0 org-pomodora-current-work)) (timestamp (nth 1 org-pomodora-current-work)) )
    (message "org-pomo-out: %s on %s" heading timestamp)
    (when heading
      (org-pomodora heading timestamp "[X]")  
      (lock-screen)
      (play-sound pomodora-sound-file)))
  )

(defun org-pomo-complete ()
  (show-alert "pomodora complete, take a long break" )

  (when org-pomodora-start-time
    (setq org-pomodora-start-time nil)
    )  

  (let ( ( heading (nth 0 org-pomodora-current-work)) (timestamp (nth 1 org-pomodora-current-work)) )
    (message "org-pomo-out: %s on %s" heading timestamp)
      (when heading
	(org-pomodora heading timestamp "[X]")
	(lock-screen)
	(play-sound pomodora-sound-file)	
	)
    )
  (setq  org-pomodora-current-work '(nil , nil))
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
(defun org-pomodora-current ()
  (interactive)
  (if (nth 0 org-pomodora-current-work)

      (let ( ( heading (nth 0 org-pomodora-current-work)) (timestamp (nth 1 org-pomodora-current-work)))
	(if org-pomodora-start-time
	    ( let ( (secs (float-time (time-subtract (current-time) org-pomodora-start-time)) ))
	      (message "%s on: %s on: %d min" heading timestamp (/ secs 60))
	      )	    
	  (message "%s on: %s in break" heading timestamp)
	  )      	
	)
      (message "no work in progress")
    )
  )

;;;###autoload
(defun org-start-pomodora ()
  " start the pomodora time tracking  "
  (interactive)
  (if (and org-pomodora-current-work (nth 0 org-pomodora-current-work))
      (message "TASK: %s in progress..." (nth 0 org-pomodora-current-work))
    (org-start-pomodora-imp))  
  )


(defun org-start-pomodora-imp ()
  " start the pomodora time tracking  "
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
  (setq  org-pomodora-timer3 (run-at-time  (format "%d min"  current-period ) nil  #'org-pomo-out))
  ;; break 10
  (setq current-period (+ current-period pomodora-break-period ))
  (setq  org-pomodora-timer4 (run-at-time  (format "%d min"  current-period ) nil  #'org-pomo-in))
  ;; work 25
  (setq current-period (+ current-period pomodora-work-period ))
  (setq  org-pomodora-timer5 (run-at-time  (format "%d min"  current-period ) nil  #'org-pomo-out))
  ;; break 10
  (setq current-period (+ current-period pomodora-break-period ))
  (setq  org-pomodora-timer6 (run-at-time  (format "%d min"  current-period ) nil  #'org-pomo-in))
  ;; work 25 complete
  (setq current-period (+ current-period pomodora-work-period ))
  (setq  org-pomodora-timer7 (run-at-time  (format "%d min"  current-period )  nil  #'org-pomo-complete))
  )



;;;###autoload
(defun org-agenda-start-pomodora ()
  (interactive)
  (let* ( (marker (or (org-get-at-bol 'org-marker)
		     (org-agenda-error)))
	 (buffer (marker-buffer marker))
	 (pos (marker-position marker)))

    (with-current-buffer buffer
      (goto-char pos)
      (message "%s" (org-get-heading))
      (org-start-pomodora)
      )    
    )
  )


;;;###autoload
(defun org-stop-pomodora ()
  " stop the pomodora time tracking  "
  (interactive)
  (message "stop all pomodora timer")
  (setq org-pomodora-start-time nil)
  
  (cancel-timer org-pomodora-timer0)
  (cancel-timer org-pomodora-timer1)
  (cancel-timer org-pomodora-timer2)
  (cancel-timer org-pomodora-timer3)
  (cancel-timer org-pomodora-timer4)
  (cancel-timer org-pomodora-timer5)
  (cancel-timer org-pomodora-timer6)
  (cancel-timer org-pomodora-timer7)
  (setq  org-pomodora-current-work '(nil nil))
  )


;; util function 
(defun org-pomodora (heading timestamp marks)
  (when (and heading  timestamp)

    (with-current-buffer (find-file-noselect pomodora-path)  
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
  )


;;;###autoload
(defun org-agenda-custom-command-n ()
  (interactive)
  (org-agenda nil "n")
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TEST CASES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;###autoload
(defun org-pomodora-test1 ()
  (interactive)
  (org-agenda nil "n")
  )


(defun org-pomodora-test ()
  (if org-pomodora-current-work
      (message "yes")
    (message "no")
    )
  
  (setq heading (org-get-heading))
  (setq timestamp (format-time-string "%Y-%m-%d"))
  (message "start work: %s on %s" heading timestamp)
  (setq  org-pomodora-current-work `(,heading ,timestamp))
  (message "out at: %s" (nth 1 org-pomodora-current-work))
  (save-excursion
    (find-file pomodora-path)
    )
  )


(defun org-pomodora-test-out ()
  (let* ( (marker (or (org-get-at-bol 'org-marker)
		     (org-agenda-error)))
	 (buffer (marker-buffer marker))
	 (pos (marker-position marker)))

    (with-current-buffer buffer
      (goto-char pos)
      (message "%s" (org-get-heading))
      (org-start-pomodora)
      )    
    )
  
  ;; (setq  org-pomodora-timer (run-at-time "1 sec" nil  #'show-alert "hello world"))
  ;; (cancel-timer org-pomodora-timer)
  )

(defun org-pomodora-test-time ()
  (if org-pomodora-start-time
      (message "%d" (float-time (time-subtract (current-time) org-pomodora-start-time)))
      (setq org-pomodora-start-time (current-time))
      )


  
  )

(provide 'pomodora)

;;; pomodora.el ends here 
