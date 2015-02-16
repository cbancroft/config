(require 'cc-mode)
					; start google-c-style with emacs
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

;; ggtags
(require 'ggtags)
;(add-hook 'c-mode-common-hook
;	  (lambda ()
;	    (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
;	      (ggtags-mode 1)
;	      )
;	    )
;)

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)

;; replace the 'completion-at-point' and 
;; 'complete-symbol' bindings in irony-mode's
;; buffers by irony-mode's function
(defun cb/irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async)
)
(add-hook 'irony-mode-hook 'cb/irony-mode-hook)

(defun cb/irony-enable ()
  (when (member major-mode irony-known-modes)
    (irony-mode 1)))
(add-hook 'c++-mode 'cb/irony-enable)
(add-hook 'c-mode 'cb/irony-enable)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
(set 'company-idle-delay .3)
