;-*- coding: utf-8 mode: emacs-lisp -*-
; 
; cbancroft's .emacs for GNU/Emacs 24.2 on Arch GNU/Linux

;* {{{ Initialization

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq gc-cons-threshold 100000000)
(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
;; Define the load path
(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/config")))


(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))


(load-user-file "config/personal.el")
(load-user-file "config/melpa.el" )
(load-user-file "config/variables.el")
(load-user-file "config/packages.el" )
(load-user-file "config/keyboard.el")
(load-user-file "config/aliases.el" )
(load-user-file "config/helm-config.el" )
(load-user-file "config/c-config.el")
(load-user-file "config/python.el")
(load-user-file "config/spaceline.el")
(load-user-file "config/theme.el")
(load-user-file "config/lookfeel.el")
(load-user-file "config/cb-org.el")
(load-user-file "config/latex.el")


(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

(setq current-language-environment "UTF-8")
(setq default-input-method "rfc1345")

(prefer-coding-system 'utf-8)

;{{{ Major modes for editing code and other formats
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("8b30636c9a903a9fa38c7dcf779da0724a37959967b6e4c714fdc3b3fe0b8653" "40f6a7af0dfad67c0d4df2a1dd86175436d79fc69ea61614d668a635c2cd94ab" "3b24f986084001ae46aa29ca791d2bc7f005c5c939646d2b800143526ab4d323" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "1a53efc62256480d5632c057d9e726b2e64714d871e23e43816735e1b85c144c" "6df30cfb75df80e5808ac1557d5cc728746c8dbc9bc726de35b15180fa6e0ad9" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "ac2b1fed9c0f0190045359327e963ddad250e131fbf332e80d371b2e1dbc1dc4" "6209442746f8ec6c24c4e4e8a8646b6324594308568f8582907d0f8f0260c3ae" "7b0433e99dad500efbdf57cf74553499cde4faf2908a2852850c04b216c41cc9" default)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-mode-line-clock ((t (:background "grey75" :foreground "red" :box (:line-width -1 :style released-button))))))
