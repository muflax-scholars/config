;;; load quicklisp
#-quicklisp
(let ((quicklisp-init (merge-pathnames "local/quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))
