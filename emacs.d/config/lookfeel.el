;* {{{ Look & Feel
;
;; Default font
;(set-default-font "-xos4-terminus-medium-r-normal-*-12-120-72-72-c-60-iso8859-2")

;Highlight the current line
(global-hl-line-mode 1)
;(set-face-background 'hl-line "color-235")
(set-face-attribute hl-line-face nil :underline nil)

;; Don't show the welcome message
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

;; Shut off message buffer
;;(setq message-log-max nil)
;;(kill-buffer "*Messages*")

;; Show column number in modeline
(setq column-number-mode t)

;; Modeline setup
;;   - somewhat cleaner than default
(setq default-mode-line-format
      '("-"
       mode-line-mule-info
       mode-line-modified
       mode-line-frame-identification
       mode-line-buffer-identification
       "  "
       global-mode-string
       "   %[(" mode-name mode-line-process minor-mode-alist "%n"")%]--"
       (line-number-mode "L%l--")
       (column-number-mode "C%c--")
       (-3 . "%p")
       "-%-")
)

;; Syntax coloring (font-lock-mode)
(global-font-lock-mode t)

;; Always flash for parens and define a more distinctive color
(show-paren-mode 1)
(set-face-foreground 'show-paren-match-face "#bc8383")

;; Answer y or n instead of yes or no at prompts
(defalias 'yes-or-no-p 'y-or-n-p)

;; Use ANSI colors within shell-mode
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;}}}

;; Linum (line numbering)
(require 'linum)

;; - do not enable by default, breaks org-mode
;(global-linum-mode)
(add-hook 'c-mode-hook #'linum-on)
(add-hook 'asm-mode-hook #'linum-on)

;{{{ Font config
(set-default-font "Monaco for Powerline 10")
;}}}
