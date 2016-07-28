(require 'cc-mode)

(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(projectile-global-mode)

; start flymake-google-cpplint-load
; lets define a function fro flymake init
(defun cb/flymake-google-init ()
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/bin/cpplint"))
  (flymake-google-cpplint-load)
)
(add-hook 'c-mode-hook 'cb/flymake-google-init)
(add-hook 'c++-mode-hook 'cb/flymake-google-init)

;;(add-hook 'c++-mode-hook 'irony-mode)
;;(add-hook 'c-mode-hook 'irony-mode)

;; replace the 'completion-at-point' and 
;; 'complete-symbol' bindings in irony-mode's
;; buffers by irony-mode's function
(defun cb/irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async)
)
;;(add-hook 'irony-mode-hook 'cb/irony-mode-hook)

(defun cb/irony-enable ()
  (when (member major-mode irony-known-modes)
    (irony-mode 1)))
;;(add-hook 'c++-mode 'cb/irony-enable)
;;(add-hook 'c-mode 'cb/irony-enable)

(require 'company)
(require 'company-irony)
(add-hook 'after-init-hook 'global-company-mode)
;;(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

(setq company-idle-delay .3
      company-backends '(company-gtags)
      company-minimum-prefix-length 2
      company-show-numbers 2
      company-tooltip-limit 20
      company-dabbrev-downcase nil)
(define-key company-mode-map (kbd "C-;") 'company-complete-common)

;; Style
(setq c-default-style "bsd"
      c-basic-offset 4)
