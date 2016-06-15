;; helm
(require 'helm)
(require 'helm-config)
(require 'helm-eshell)
(require 'helm-files)
(require 'helm-grep)
(require 'helm-swoop)
(require 'helm-projectile)
(require 'helm-buffers)
(require 'helm-mode)
(require 'helm-misc)


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


(defun malb/helm-omni (&rest arg)
  ;; just in case someone decides to pass an argument, helm-omni won't fail.
  (interactive)
  (unless helm-source-buffers-list
    (setq helm-source-buffers-list
          (helm-make-source "Buffers" 'helm-source-buffers)))
  (helm-other-buffer
   (append

    (if (projectile-project-p)
        '(helm-source-projectile-buffers-list
          helm-source-buffers-list)
      '(helm-source-buffers-list)) ;; list of all open buffers

    (if (projectile-project-p)
        '(helm-source-projectile-recentf-list
          helm-source-recentf)
      '(helm-source-recentf)) ;; all recent files

    '(helm-source-files-in-current-dir) ;; files in current directory

    '(helm-source-locate               ;; file anywhere
      helm-source-bookmarks            ;; bookmarks too
      helm-source-buffer-not-found     ;; ask to create a buffer otherwise
      )

    ) "*Helm all the things*"))

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-b") 'malb/helm-omni)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-c h o") 'helm-occur)
;rebind the buffer finder
(global-set-key (kbd "C-x b") 'helm-mini)
; rebind tab to do persistent action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
; make TAB work in terminal
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(global-set-key (kbd "<f9> /") 'helm-swoop)
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
      helm-input-idle-delay 0.01
      helm-bookmark-show-location t
      helm-org-headings-fontify t
)
(helm-mode 1)

;; helm-ag
(setq helm-ag-base-command "ag --nocolor --nogroup"
      helm-ag-command-option "--all-text"
      helm-ag-insert-at-point 'symbol
      helm-ag-fuzzy-match t
      helm-ag-use-grep-ignore-list t
      helm-ag-use-agignore t)


(require 'helm-gtags)
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 
)
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
(define-key helm-gtags-mode-map (kbd "C-c g s") 'helm-gtags-find-symbol)
(define-key helm-gtags-mode-map (kbd "C-c g r") 'helm-gtags-find-rtag)
(define-key helm-gtags-mode-map (kbd "C-c g f") 'helm-gtags-parse-file)
(define-key helm-gtags-mode-map (kbd "C-c g c") 'helm-gtags-create-tags)
(define-key helm-gtags-mode-map (kbd "C-c g u") 'helm-gtags-update-tags)


;; projectile config
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-mode-line  '(:eval
			      (format " ⛕[%s]"
				      (projectile-project-name))))
(setq projectile-switch-project 'helm-projectile)
(progn
  (defvar malb/helm-source-file-not-found
    (helm-build-dummy-source
	"Create file"
      :action 'find-file))
  (add-to-list
   'helm-projectile-sources-list
   malb/helm-source-file-not-found t)
  
  (helm-delete-action-from-source
   "Grep in projects `C-s'"
   helm-source-projectile-projects)
  
  (helm-add-action-to-source
   "Grep in projects `C-s'"
   'helm-do-ag helm-source-projectile-projects 4))


;; helm-swoop
(defun cb/helm-swoop-pre-fill ()
  (thing-at-point 'symbol))

(setq cb/helm-swoop-ignore-major-mode
  '(dired-mode paradox-menu-mode doc-view-mode pdf-view-mode mu4e-headers-mode))
(defun cb/swoop-or-search ()
  (interactive)
  (if (or (> (buffer-size) 1048576) ;; helm-swoop can be slow on big buffers
	  (memq major-mode cb/helm-swoop-ignore-major-mode))
      (isearch-forward)
    (helm-swoop)
    ))


(global-set-key (kbd "C-c o") 'helm-multi-swoop-org)
(global-set-key (kbd "C-s") 'cb/swoop-or-search)
(global-set-key (kbd "C-S-s") 'helm-multi-swoop-all)
(global-set-key (kbd "C-r") 'helm-resume)

(setq helm-swoop-pre-input-function #'cb/helm-swoop-pre-fill
      helm-swoop-split-with-multiple-windows nil
      helm-swoop-speed-or-color t)

(define-key helm-swoop-map (kbd "C-S-s") #'helm-multi-swoop-all-from-helm-swoop)
(define-key helm-swoop-map (kbd "C-r") #'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") #'helm-next-line)
(define-key helm-multi-swoop-map (kbd "C-r") #'helm-previous-line)
(define-key helm-multi-swoop-map (kbd "C-s") #'helm-next-line)
