;; eval-last-sexp
(+ 1 2 )
(< 3 4)

;; print 
(message "hi")


(integerp 3)


(if t "yes" "no")


(equal 4 3)


;; set variable
(let (x y (z 1)) 
(setq x 10 y 2)
(+ x y z)
)

;; eval-region
(progn (message "a") (message "b"))

(let ((i 0))
(while ( < i 4 )
  (print i )
  (setq i (+ 1 i))))


;; eval first, then execute 
(defun test (start, end)
  "doc"
  (interactive)
  (insert "yeah")
  )


;; 
(defun test1(myStart myEnd)
  "print argument"
  (interactive "r")
  (message "Region begin at: %d, end at: %d" myStart myEnd)
  )

;; universal arg Ctr+u
(defun test2(arg)
  (interactive "p")
  (message "arg: %d" arg)
  )


;; A function with the (interactive …) clause is called a command, and can be called by execute-extended-command (that is, pressing 【Alt+x】).


(point)

(goto-char 39)


;; strings

(length "abc")


(buffer-name)


(find-file "~/")




(defun insert-p-tag ()
  "insert <p> at cursor point"
  (interactive)
  (insert "<p></p>")
  (backward-char 4))



