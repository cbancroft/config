;{{{ Key bindings
;    - with switched Caps_Lock and Control_L keys system wide

;{{{ Main bindings
;
;; C-w to backward kill for compatibility (and ease of use)
(global-set-key "\C-w"     'backward-kill-word)
;; ...and then provide alternative for cutting
(global-set-key "\C-x\C-k" 'kill-region)

;; Change C-x C-b behavior (buffer management)
(global-set-key "\C-x\C-b" 'electric-buffer-list)

;; Reload or edit .emacs as defined above
(global-set-key "\C-c\C-r" 'aic-reload-dot-emacs)
(global-set-key "\C-c\C-e" 'aic-edit-dot-emacs)

;; Toggle soft word wrapping
(global-set-key "\C-cw" 'toggle-truncate-lines)

;; Quick access to the speedbar
;; (global-set-key "\C-cs" 'speedbar-get-focus)

;; Quicker access to go-to line

(global-set-key (kbd "M-g") 'goto-line)

;; Menu bar toggle, as in my vimperator setup
(global-set-key (kbd "<M-down>") 'menu-bar-mode)

;; Jump to the start/end of the document with C-PgUP/DN
(global-set-key [C-prior] (lambda () (interactive) (goto-char (point-min))))
(global-set-key [C-next]  (lambda () (interactive) (goto-char (point-max))))

;; Require C-x C-c prompt, no accidental quits
(global-set-key [(control x) (control c)] 
  (function 
   (lambda () (interactive) 
     (cond ((y-or-n-p "Quit? ")
       (save-buffers-kill-emacs)))))
)

;; Easy window changing
(global-set-key (kbd "C-c <left>") 'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>") 'windmove-up)
(global-set-key (kbd "C-c <down>") 'windmove-down)
;}}}

;{{{ Fn bindings
;
(global-set-key  [f1]  (lambda () (interactive) (manual-entry (current-word))))
;f2 in cb-org.el
;f3 in cb-org.el
(global-set-key  [f4]  'aic-visit-ansi-term)      ; Function defined previously
;f5 in cb-org.el
(global-set-key  (kbd "<f6> l")  'linum-mode)     ; Toggle line numbering
;(global-set-key  (kbd "<f6> c")  'calendar)       ; Toggle calendar
;(global-set-key  (kbd "<f6> I")  'cb/clock-in)    ; Clock in
;(global-set-key  (kbd "<f6> O")  'cb/clock-out)   ; Clock out
(global-set-key  (kbd "<f6> h")  'cb/hide-other)  ; Hide other windows?
;(global-set-key  (kbd "<f6> i")  'cb/org-info)    ; Get info on org
(global-set-key  [f7]  'htmlfontify-buffer)
;; (global-set-key  [f8]  'ispell-buffer)
;; (global-set-key  [f9]  'ispell-change-dictionary) ; Switching 'en_US' and 'hr' often
;(global-set-key [f10]                            ; Quick menu by default

;(global-set-key  [f11] 'speedbar)
(global-set-key  [f12] 'kill-buffer)
;}}}
;}}}
