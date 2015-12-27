;-*- coding: utf-8 mode: emacs-lisp -*-
; 
; cbancroft's .emacs for GNU/Emacs 24.2 on Arch GNU/Linux

;* {{{ Initialization

(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
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
(load-user-file "config/keyboard.el")
(load-user-file "config/aliases.el" )
(load-user-file "config/c-config.el")
(load-user-file "config/python.el")
(load-user-file "config/helm-config.el" )
(load-user-file "config/theme.el")
(load-user-file "config/lookfeel.el")
(load-user-file "config/cb-org.el")
(load-user-file "config/cb-gnus.el")
(load-user-file "config/cb-bbdb.el")
(load-user-file "config/packages.el" )
;{{{ Major modes for editing code and other formats
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (warm-night)))
 '(custom-safe-themes
   (quote
    ("6209442746f8ec6c24c4e4e8a8646b6324594308568f8582907d0f8f0260c3ae" "7b0433e99dad500efbdf57cf74553499cde4faf2908a2852850c04b216c41cc9" default)))
 '(flymake-google-cpplint-command "/usr/bin/cpplint")
 '(safe-local-variable-values
   (quote
    ((company-clang-arguments "-I/home/cbancroft/work/aridswamp/master/phase_2/runtime/arm/aridswamp_mod/inc/" "-I/home/cbancroft/work/aridswamp/master/phase_2/runtime/arm/kit/includes/"))))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "unknown" :slant normal :weight normal :height 60 :width normal))))
 '(org-mode-line-clock ((t (:background "grey75" :foreground "red" :box (:line-width -1 :style released-button)))) t))
