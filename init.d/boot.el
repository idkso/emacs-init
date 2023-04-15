(defun init/mount (type opts mountpoint &optional device)
  (message "mounted %s at %s" type mountpoint)
  (init/run "/bin/mount" "-n" "-t" type "-o" opts (or device type) mountpoint))

(defun init/make-directory (dir &optional mode)
  (unless (file-exists-p dir)
	(make-directory dir t)
	(if mode (set-file-modes dir mode))))

;; mount some necessary filesystems
(init/mount "proc" "nosuid,noexec,nodev" "/proc")
(init/mount "sysfs" "nosuid,noexec,nodev" "/sys")
(init/mount "tmpfs" "mode=0755,nosuid,nodev" "/run" "run")
(init/mount "devtmpfs" "mode=0755,nosuid" "/dev" "dev")
(init/make-directory "/dev/pts/")
(init/mount "devpts" "gid=5,mode=0620,nosuid,noexec" "/dev/pts")
(init/make-directory "/dev/shm/" #o755)
(init/mount "tmpfs" "mode=1777,nosuid,nodev" "/dev/shm" "shm")

(message "loading kernel modules...")
(init/run "/bin/loadmods")

(message "starting udev...")
(init/run "/bin/udevadm" "control" "--exit")
(init/run "/bin/udevd" "--daemon")
(init/run "/bin/udevadm" "trigger" "--action=add" "--type=subsystems")
(init/run "/bin/udevadm" "trigger" "--action=add" "--type=devices")

;; remounting /
(message "remounting /...")
(init/run "/bin/mount" "-o" "remount,rw" "/")
;; mounting everything
(message "mounting everything...")
(init/run "/bin/mount" "-a")


(init/make-directory "/run/" #o755)
(init/make-directory "/run/runit/" #o755)
(init/make-directory "/run/lvm/" #o755)
(init/make-directory "/run/user/" #o755)
(init/make-directory "/run/lock/" #o755)
(init/make-directory "/run/log/" #o755)

(message "setting hostname to %s" hostname)
(init/run "/bin/hostname" hostname)

(message "seeding rng...")
(init/start "/bin/seedrng")
(init/start "/bin/ip" "link" "set" "up" "dev" "lo")

(message "starting agetty...")

(init/start "/bin/agetty" "--noclear" "tty1" "38400" "linux")
(init/start "/bin/agetty" "tty2" "38400" "linux")
(init/start "/bin/agetty" "tty3" "38400" "linux")
(init/start "/bin/agetty" "tty4" "38400" "linux")
(init/start "/bin/agetty" "-a" "root" "tty6" "38400" "linux")

(server-start)
