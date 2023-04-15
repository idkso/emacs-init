(setq-local iface "wlp3s0")
(setq-local config "/etc/wpa_supplicant/wpa_supplicant.conf")

(message "starting wpa_supplicant")
(init/start "/bin/wpa_supplicant" "-B" "-i" iface "-c" config)
(init/start "/bin/dhcpcd")
