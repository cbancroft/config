;; helm
(require 'helm)
(require 'helm-config)
(require 'helm-eshell)
(require 'helm-files)
(require 'helm-grep)

;; The default "C-x c" is too close to "C-x C-c", which quits Emacs.
;; Change it to "C-c h".
(global-set-key (kbd "C-c h") 'helm-command-prefix)

(global-unset-key (kbd "C-x c"))

(defun cb/open-file ()
  "Open file using projectile+helm, or just helm"
  (interactive)
  (if (projectile-project-p)
      (helm-projectile)
    (helm-find-files nil))
  )

(global-set-key (kbd "C-x C-f") 'cb/open-file)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-c h o") 'helm-occur)
;rebind the buffer finder
(global-set-key (kbd "C-x b") 'helm-mini)
; rebind tab to do persistent action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
; make TAB work in terminal
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
; list actions using C-z
(define-key helm-map (kbd "C-z") 'helm-select-action)


(define-key helm-grep-mode-map (kbd "<return>") 'helm-grep-mode-jump-other-window )
(define-key helm-grep-mode-map (kbd "n") 'helm-grep-mode-jump-other-window-forward)
(define-key helm-grep-mode-map (kbd "p") 'helm-grep-mode-jump-other-window-backward)

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-quick-update                 t ; do not display invisible candidates
      helm-split-window-in-side-p       t ; open helm buffer inside current window, not occupy whole other
      helm-buffers-fuzzy-matching       t ; fuzzy matching buffer names when non-nil
      helm-move-to-line-cycle-in-source t ; move to end or beginning of source when reaching top or bottom
      helm-ff-search-library-in-sexp    t ; search for library in 'require' and 'declare-function' sexp
      helm-ff-file-name-history-use-recentf t;
      helm-scroll-amount                8 ; scroll 8 lines other window using M-<next>/M-<prior>
)
(helm-mode 1)

(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
)

(require 'helm-gtags)

(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)


