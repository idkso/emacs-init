;; startup message
(message "chad emacs init started...")

;; config options
(setq init-d "/etc/init.d/")
(setq hostname "localhost")

;; load common stuff (mostly init/ namespace)
(load-file (concat init-d "common.el"))

(load-file (init/get-file "boot.el"))

(load-file (init/get-file "wpa_supplicant.el"))

(message "all done")
