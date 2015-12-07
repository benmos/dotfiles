
(defun benmos/filter (condp lst)
    (delq nil
          (mapcar (lambda (x) (and (funcall condp x) x)) lst)))

(defun benmos/tunnels ()
  "Spawn SSH Tunnels"
  (interactive)
  ;; eg: "ssh -i ~/.ssh/adminuser -L 8083:localhost:8083 ops@ops.borde.rs"
  (benmos/spawn-tunnel 3730 3729 "id_rsa" "ben_moseley" "prod-propane-app-server.borde.rs" )
  (benmos/spawn-tunnel 3729 3729 "id_rsa" "ben_moseley" "dev-propane-app-server.borde.rs" )
  (benmos/spawn-tunnel 5555 5555 "id_rsa" "ops"       "ops.borde.rs" )
  (benmos/spawn-tunnel 5556 5556 "id_rsa" "ops"       "ops.borde.rs" )
  (benmos/spawn-tunnel 8086 8086 "id_rsa" "ops"       "ops.borde.rs")
  (benmos/spawn-tunnel 8083 8083 "id_rsa" "ops"       "ops.borde.rs")

  (benmos/spawn-tunnel 7086 7086 "id_rsa" "ben_moseley" "prod-propane-automation.borde.rs")
  (benmos/spawn-tunnel 7083 7083 "id_rsa" "ben_moseley" "prod-propane-automation.borde.rs")
  (benmos/spawn-tunnel 8477 8477 "id_rsa" "ben_moseley" "prod-propane-automation.borde.rs") ;; Apache serving Grafana

  (benmos/spawn-tunnel 6086 7086 "id_rsa" "ben_moseley" "dev-propane-automation.borde.rs")
  (benmos/spawn-tunnel 6083 7083 "id_rsa" "ben_moseley" "dev-propane-automation.borde.rs")
  ;; (benmos/spawn-tunnel 8476 8477 "id_rsa" "ben_moseley" "dev-propane-automation.borde.rs") ;; Apache serving Grafana ; 'deploy/nix/ops/conf/borders-grafana-config.js' hard-codes the InfluxDB address to 'http://localhost:7086/db/Stats' ... ie Prod.

  (benmos/spawn-tunnel 5432 5432 "id_rsa" "ben_moseley" "dev-propane-app-server.borde.rs")
  )

(defun benmos/kill-tunnels ()
  "Kill All SSH Tunnels"
  (interactive)
  (let ((tbufs (benmos/filter (lambda (b) (string-match "\\*tunnel\\*" (buffer-name b))) (buffer-list)))
	(kill-buffer-query-functions '()))
    (mapcar 'kill-buffer tbufs))
  )

(defun benmos/borders ()
  "Spawn shells for all Borders EC2 VMs, Spawn Direds etc"
  (interactive)
  (benmos/spawn-borders-shell "dev-propane-app-server"  '("su - borders"))
  (benmos/spawn-borders-shell "dev-propane-automation"  '("su - borders"))
  (benmos/spawn-borders-shell "prod-propane-app-server" '("su - borders"))
  (benmos/spawn-borders-shell "prod-propane-automation" '("su - borders"))

  ;; (benmos/spawn-borders-shell "prod-radon-app-server" '("su - borders"))
  ;; (benmos/spawn-borders-shell "prod-radon-automation" '("su - borders"))

  (benmos/spawn-remote "dev-propane-app-server.borde.rs"  "dev-app-DB-propane"   '("psql borders"))
  (benmos/spawn-remote "dev-propane-automation.borde.rs"  "dev-auto-DB-propane"  '("psql scraper"))
  (benmos/spawn-remote "prod-propane-app-server.borde.rs" "prod-app-DB-propane"  '("psql borders"))
  (benmos/spawn-remote "prod-propane-automation.borde.rs" "prod-auto-DB-propane" '("psql scraper"))

  ;; (benmos/spawn-remote "prod-radon-app-server.borde.rs" "prod-radon-app-server-DB" '("psql borders"))
  ;; (benmos/spawn-remote "prod-radon-automation.borde.rs" "prod-radon-automation-DB" '("psql scraper"))

  (benmos/spawn-remote "ops.borde.rs" "ops.borders" '())
  ;; (benmos/spawn-remote "-p 2222 bob@localhost" "bob-local" '("cd /hostshare/server"))
  ;; (benmos/spawn-remote "-p 2222 bob@localhost" "bob-local2" '("cd /hostshare/server"))
  (benmos/spawn-remote "bob" "bob-local" '("cd /hostshare/server"))
  (benmos/spawn-remote "bob" "bob-local2" '("cd /hostshare/server"))
  (benmos/spawn-remote "bob" "bob-local3" '("cd /hostshare/server"))
  (benmos/spawn-remote "bob" "bob-tunnel1" '("ssh -i ~/.ssh/john_smith -L 5432:localhost:5432 john_smith@dev-propane-app-server.borde.rs"))
  (benmos/spawn-remote "bob" "bob-tunnel2" '("ssh -i ~/.ssh/john_smith -L 5433:localhost:5432 john_smith@dev-propane-automation.borde.rs"))
  (benmos/spawn-local  "local-server" "/Users/ben/Startup2/code/server/" '())
  (benmos/spawn-local  "gen" "/Users/ben/Startup2/code/server/" '())
  (dired "/ssh:bob@localhost#2222:/")
  (dired "~/Startup2/code")
  )

(defun benmos/spawn-borders-shell (name cmds)
  "Create a Borders remote-login-shell"
  (benmos/spawn-remote (concat name ".borde.rs") name cmds))

(defun benmos/spawn-remote (host name cmds)
  "Create a remote-login-shell"
    (let ((buf (get-buffer-create (generate-new-buffer-name (concat "*shell*" name)))))
      (shell buf)
      (process-send-string buf (concat "ssh " host "\n"))
      (mapcar (lambda (cmd) (process-send-string buf (concat cmd "\n"))) cmds)))

(defun benmos/spawn-tunnel (localport remport keyfilename user host)
  "Create an ssh tunnel"
    (let ((buf (get-buffer-create (generate-new-buffer-name (concat "*tunnel*" host ":" (number-to-string remport))))))
      (shell buf)
      (process-send-string buf (concat "ssh -i ~/.ssh/" keyfilename " -L " (number-to-string localport) ":localhost:" (number-to-string remport) " " user "@" host "\n"))))

(defun benmos/spawn-local (name dir cmds)
  "Create a local-shell"
    (let ((buf (get-buffer-create (generate-new-buffer-name (concat "*shell*" name)))))
      (with-current-buffer buf (setq default-directory dir)) ; buffer-local variable
      (shell buf)
      (mapcar (lambda (cmd) (process-send-string buf (concat cmd "\n"))) cmds)))

(defun benmos/bg ()
  "Set the frame config to have three large frames"
  (interactive)
  (if (> (length (frame-list)) 1) (mapcar 'delete-frame (cdr (frame-list)))) ; Delete all frames but one
  (let ((frame1 (selected-frame)) ;; Reuse old-frame as frame1
        (frame2 (new-frame '((height . 113) (width . 260) (left . 840) (top . 0))))
        )
    (set-frame-height frame1 113)
    (set-frame-width frame1 130)
    (set-frame-position frame1 20 0)
    (delete-other-windows)
    (split-window-vertically)
    (select-frame frame1))
  )

(defun benmos/bg3 ()
  "Set the frame config to have three large frames"
  (interactive)
  (if (> (length (frame-list)) 1) (mapcar 'delete-frame (cdr (frame-list)))) ; Delete all frames but one
  (let ((frame1 (selected-frame)) ;; Reuse old-frame as frame1
        (frame2 (new-frame '((height . 113) (width . 130) (left . 840) (top . 0))))
        (frame3 (new-frame '((height . 113) (width . 130) (left . 1660) (top . 0))))
        )
    (set-frame-height frame1 113)
    (set-frame-width frame1 130)
    (set-frame-position frame1 20 0)
    (delete-other-windows)
    (split-window-vertically)
    (select-frame frame3)
    (split-window-vertically)
    (select-frame frame1))
  )

(defun benmos/move-to-window-line-zero ()
  (interactive)
  (move-to-window-line 0))

(defun benmos/back-to-indentation ()
  "Move to first non-whitespace char of line."
  (interactive)
  (back-to-indentation))

(defun benmos/up-one-line ()
  (interactive)
  (scroll-up 1))

(defun benmos/down-one-line ()
  (interactive)
  (scroll-up -1))

;; Window swapping
(defun benmos/transpose-windows (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        ;;(select-window (funcall selector))
        )
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))

(defun benmos/fixup-paragraph-regexps ()
  "fix paragraph movement broken by haskell-mode"
  (interactive)
  (kill-local-variable 'paragraph-start)
  (kill-local-variable 'paragraph-separate)
  (set (make-local-variable 'paragraph-separate) "[ \t\f]*$")
  (set (make-local-variable 'paragraph-start) "[ \t\f]*$")
  )

(defun benmos/show-buf-name-header ()
  "Append the dir buffer name."
  (interactive)
  (setq header-line-format '(:eval (buffer-file-name))))

(defun benmos/show-dired-name-header ()
  "display dired full pathname in header line"
  (setq header-line-format '(:eval (dired-get-file-for-visit)))
  )

(defun benmos/set-dired-buf-name ()
  "prepend 'dired' to buffer name."
  (interactive)
  (rename-buffer (concat "dired-" (buffer-name)) t))

(defun benmos/shell-sync-dir-with-prompt (string)
"A preoutput filter function (see `comint-preoutput-filter-functions')
which sets the shell buffer's path to the path embedded in a prompt string.
This is a more reliable way of keeping the shell buffer's path in sync
with the shell, without trying to pattern match against all
potential directory-changing commands, ala `shell-dirtrack-mode'.

In order to work, your shell must be configured to embed its current
working directory into the prompt.  Here is an example .zshrc
snippet which turns this behavior on when running as an inferior Emacs shell:

  if [ $EMACS ]; then
     prompt='|Pr0mPT|%~|[%n@%m]%~%# '
  fi

[BM] For Bash you can use:

  PS1=\"|Pr0mPT|\w|\s-\v$ \"

The part that Emacs cares about is the '|Pr0mPT|%~|'
Everything past that can be tailored to your liking.
"
(if (string-match "|Pr0mPT|\\([^|]*\\)|" string)
    (let ((cwd (match-string 1 string)))
      (setq default-directory
            (if (string-equal "/" (substring cwd -1))
                cwd
              (setq cwd (concat cwd "/"))))
      (replace-match "" t t string 0))
  string))
