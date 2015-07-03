(setq scroll-margin 0)
(setq savehist-mode nil)
(setq ido-default-buffer-method (quote selected-window))
(setq dired-recursive-copies 'top)              ; Allow dired 'C' to copy dirs
(setq comint-buffer-maximum-size 9999)
(setq projectile-completion-system 'helm-comp-read)
(setq projectile-tags-command "hasktags -Re -f %s %s")
(setq magit-last-seen-setup-instructions "1.4.0")
(setq dired-use-ls-dired nil)

(setq helm-grep-default-command "ggrep -a -d skip %e -n%cH -e %p %f") ; Use 'ggrep'
(setq helm-ff-skip-boring-files t)
(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

;(add-to-list 'dired-omit-extensions "hi")

;
; IBuffer Config
;
;; The following would need a (require 'ibuffer) which I'd prefer to avoid:
;; (define-ibuffer-column size-h
;;   (:name "Size" :inline t)
;;   (cond
;;    ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
;;    ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
;;    (t (format "%8d" (buffer-size)))))

(setq ibuffer-formats
      '((mark modified read-only " "
	 (name 31 31 :left :elide) " "
	 ;; (size-h 7 -1 :right) " " ;; see above for why this is commented out
	 (size 7 -1 :right) " "
	 (mode 16 16 :left :elide) " "
	 filename-and-process)
	(mark " "
	 (name 16 -1) " "
	 filename)))

(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("dired" (mode . dired-mode))
	       ("haskell" (mode . haskell-mode))
	       ("objc" (mode . objc-mode))
	       ("java" (mode . java-mode))
	       ("shell" (mode . shell-mode))
	       ("emacs" (or
			 (name . "^\\*scratch\\*$")
			 (name . "^\\*Messages\\*$")))))))


;
; Hooks
;
(add-to-hooks 'linum-mode '(c-mode-hook c++-mode-hook haskell-mode-hook lisp-mode-hook js-mode-hook))
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)
(add-hook 'dired-mode-hook   'benmos/set-dired-buf-name)
(add-hook 'dired-mode-hook   'benmos/show-dired-name-header)
(add-hook 'find-file-hook    'benmos/show-buf-name-header)
(add-hook 'haskell-mode-hook 'benmos/fixup-paragraph-regexps) ;; this is because Haskell mode imposes daft values for these....
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'ibuffer-mode-hook (lambda () (ibuffer-switch-to-saved-filter-groups "default")))
(add-hook 'shell-mode-hook
        #'(lambda ()
            (shell-dirtrack-mode nil)
            (add-hook 'comint-preoutput-filter-functions
                      'benmos/shell-sync-dir-with-prompt nil t)))

;
; Modes
;
(require 'helm-config)
(helm-mode 1)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(tool-bar-mode -1)

;
; Not needed with emacs-mac-port (IIUC):
;
(setq mac-command-key-is-meta t)
(setq mac-pass-command-to-system nil)
(setq mac-pass-control-to-system nil)
(setq mac-option-modifier 'alt)
(setq mac-control-modifier 'control)
(setq mac-command-modifier 'meta)

;
; Other random...
;

;;
;; From Aaron: [AFAICS This is basically a sticking plaster if you've
;; not managed to get the OS-level $PATH inherited by Emacs.app set
;; correctly]
;; [turns out that I basically need this sticking plaster ... as I
;;  can't figure out a *clean* way to do this OSX-wide (on a per-user
;;  basis) for OS X GUI apps. {it should be ~/.launchd.conf - but
;;  that's not yet implemented on OSX :-( }
;;  ]
;;
;; What this (basically) does internally is:
;;
;;   * Run /bin/bash interactive login shell
;;   * Examine the value of $PATH under that
;;   * call (setenv "PATH" ...) inside emacs to set it up there
;;   * copy it to all the other relevant parts of emacs (eg 'exec-path', 'eshell' etc...)
;;
;; [NB - Needs 'exec-path-from-shell' package]:
(when (memq window-system '(mac ns))
 (exec-path-from-shell-initialize))
;;
