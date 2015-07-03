;
; High-Priority (ie Overriding all others) Key Bindings
; See: [http://emacs.stackexchange.com/questions/352/how-to-override-major-mode-bindings]
; It /might/ be better to write my own minor mode....?
;
; NB - THESE (the 'bind-key*' macro) USE SLIGHTLY DIFFERENT SYNTAX
;
; [NB - Needs 'bind-key' package]:
(bind-key* "M-o" 'other-window)
;(bind-key* "M-p" 'backward-paragraph) ; too-high priority (breaks shell-mode etc)
;(bind-key* "M-n" 'forward-paragraph)  ; too-high priority (breaks shell-mode etc)
(bind-key* "C-M-o"   'other-frame) ; More useful than split-line because easier to type than C-x 5 2
(bind-key* "C-c m"   'bury-buffer)
(bind-key* "C-x C-b" 'ibuffer)
(bind-key* "C-M-m"   'magit-status)
;(bind-key* "C-M-m"   'helm-browse-project) ; This is pretty useful too, but less so than 'magit-status


;
; Normal Priority Key Bindings
;

;; (global-set-key "\M-o" 'other-window)
(global-set-key "\M-p" 'backward-paragraph)
(global-set-key "\M-n" 'forward-paragraph)
(global-set-key "\M-l" 'revert-buffer)  ; more useful than downcase-word...
(global-set-key "\M-t" 'c-backward-into-nomenclature)
(global-set-key "\M-i" 'c-forward-into-nomenclature)
(global-set-key "\M-u" 'benmos/move-to-window-line-zero) ; more useful than upcase-word...
(global-set-key "\M-a" 'benmos/up-one-line)    ; more useful than beginning-of-sentence
(global-set-key "\M-e" 'benmos/down-one-line)  ; more useful than end-of-sentence
(global-set-key "\M-m" 'benmos/back-to-indentation)
(global-set-key "\M-+" #'(lambda () (interactive) (switch-to-buffer (clone-indirect-buffer (buffer-name) '()))))

(global-set-key "\C-t"  'benmos/transpose-windows) ;; More useful than transpose chars
(global-set-key "\C-\M-a" 'align-regexp)
(global-set-key "\C-x\C-j" 'dired-jump) ;; Set up dired-x jump to load itself

(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c g") 'helm-git-grep)
; (global-set-key (kbd "C-c h o") 'helm-occur)
; (global-set-key (kbd "C-c h g") 'helm-google-suggest)

(eval-after-load 'helm '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))

(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
