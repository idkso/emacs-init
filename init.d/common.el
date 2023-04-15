(defun init/handle-exit (proc ev)
  (message "process '%s' had event '%s'" proc (substring ev 0 -1))
  (process-exit-status proc))

(defun init/get-file (file)
  (concat init-d file))

(defun init/start (program &rest args)
  (make-process
   :name program
   :buffer (generate-new-buffer program)
   :command (cons program args)
   :sentinel 'init/handle-exit))

(defun init/run (program &rest args)
  (let ((buffer (generate-new-buffer program)))
	(apply 'call-process program nil buffer nil args)
	(with-current-buffer buffer
	  (message (buffer-string)))))
