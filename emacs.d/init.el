;; Use a hook so the startup message doesn't get clobbered
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "Emacs ready in %s with %d garbage collections."
		     (format "%.2f seconds"
			     (float-time
			      (time-subtract after-init-time before-init-time)))
		     gcs-done)))

;; Fix garbage collection to make emacs start faster
(setq gc-cons-threshold most-positive-fixnum gc-cons-percentage 0.6)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
	gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org"   . "https://orgmode.org/elpa"))

(package-initialize)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; (unless (package-installed-p 'spacemacs-theme)
;;   (package-refresh-contents)
;;   (package-install 'spacemacs-theme))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))

;; Process literate configuration files
(when (file-readable-p "~/.emacs.d/config.org")
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))

;; Pull in any custom set variables
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backups"))))
 '(custom-enabled-themes (quote (spacemacs-dark)))
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(package-selected-packages
   (quote
    (htmlize company-shell company-lua slime-company slime company-jedi company-c-headers flycheck-clang-analyzer flycheck zzz-to-char linum-relative projectile zerodark-theme json-mode gitlab helm-gitlab ivy-gitlab magit magit-find-file magit-lfs magit-todos sphinx-mode graphviz-dot-mode scratch yasnippet-snippets yasnippet company-irony expand-region mark-multiple swiper popup-kill-ring dmenu diminish spaceline company dashboard rainbow-delimiters sudo-edit hungry-delete switch-window rainbow-mode rainbow avy smex ido-vertical-mode org-bullets beacon which-key spacemacs-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#292b2e" :foreground "#b2b2b2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 108 :width normal :foundry "outline" :family "Fira Mono for Powerline")))))
