;; JEDI
;; Standard Jedi.el setting
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; rope and such
(require 'pymacs)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

;{{{ Python mode
;
;; ipython is my shell of choice, glad to have it here
(defcustom python-python-command "ipython -cl"
  "Shell command to run Python interpreter."
  :group 'python
  :type 'string
)
;}}}
