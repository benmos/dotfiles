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
 '(ring-bell-function (quote ignore) t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "nil" :family "Monaco"))))
 '(linum ((t (:inherit shadow :height 0.9 :width condensed)))))

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
