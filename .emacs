;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

   ;;   (git :variables
   ;;        ;; git-magit-status-fullscreen f
   ;;        git-enable-github-support t
   ;;        git-gutter-use-fringe t)

   ;; dotspacemacs-themes '(tangotango
   ;;                       naquadah
   ;;                       solarized-light
   ;;                       solarized-dark
   ;;                       leuven
   ;;                       monokai
   ;;                       zenburn)


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/private/benmos/")
(load-library "enable-melpa.el")
(load-library "from-spacemacs.el")
(load-library "config.el")
(load-library "funcs.el")
(load-library "keybindings.el")
(load-library "markerpen.el")

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(package-selected-packages
   (quote
    (markdown-mode nix-mode magit helm-projectile helm-ls-git helm-git-grep haskell-mode git-gutter-fringe exec-path-from-shell clojure-mode bind-key)))
 '(ring-bell-function (quote ignore)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "gray7" :foreground "green" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "nil" :family "Monaco"))))
 '(linum ((t (:inherit shadow :height 0.9 :width condensed))))
 '(magit-diff-del ((t (:inherit diff-removed :foreground "dark red"))))
 '(magit-diff-file-header ((t (:inherit diff-file-header :foreground "gray0"))))
 '(magit-item-highlight ((t (:inherit secondary-selection :background "midnight blue")))))

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
