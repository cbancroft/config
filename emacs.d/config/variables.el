;; Tool bar modes
;; {{{
;; Turn off the toolbar
(tool-bar-mode -1)
;;
;; Turn off the menu bar
(menu-bar-mode -1)
;;
;; Turn off the scrollbar
(scroll-bar-mode -1)

; }}}

;{{{ General settings
;
;; Provide an error trace if loading .emacs fails
(setq debug-on-error t)

;; Encoding
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Spell checking
(setq-default ispell-program-name "aspell"
  ispell-extra-args '("--sug-mode=ultra"))
(setq-default ispell-dictionary "en_US")

;; Default Web Browser
(setq browse-url-browser-function 'browse-url-chromium)

;; Show unfinished keystrokes early
(setq echo-keystrokes 0.1)

;; Ignore case on completion
(setq completion-ignore-case t
  read-file-name-completion-ignore-case t)


;; Save after a certain amount of time.
(setq auto-save-timeout 1800)
;;
;; Change backup behavior to save in a specified directory
(setq backup-directory-alist '(("." . "~/.emacs.d/saves/"))
 backup-by-copying      t
 version-control        t
 delete-old-versions    t
 kept-new-versions      6
 kept-old-versions      2
)

;; Keep bookmarks in the load path
(setq bookmark-default-file "~/.emacs.d/emacs-bookmarks")

;; Keep abbreviations in the load path
(setq abbrev-file-name "~/.emacs.d/emacs-abbrev-defs")

;; Default major mode
(setq default-major-mode 'text-mode)


;; Wrap lines at 70 in text-mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Text files end in new lines.
(setq require-final-newline t)

;; Narrowing enabled
(put 'narrow-to-region 'disabled nil)

;{{{ Mouse and cursor settings
;
;; Enable mouse scrolling
(mouse-wheel-mode t)

;; Push the mouse out of the way on cursor approach
(mouse-avoidance-mode 'jump)

;; Stop cursor from blinking
(blink-cursor-mode nil)

;; Acclerate the cursor when scrolling
(load "accel" t t)
;;
;; Start scrolling when 2 lines from top/bottom
(setq scroll-margin 2)
;;
;; Fix the scrolling on jumps between windows
(setq scroll-conservatively 5)

;; Cursor in same relative row and column during PgUP/DN
(setq scroll-preserve-screen-position t)

;; Always paste at the cursor
(setq mouse-yank-at-point t)

;; Kill (and paste) text from read-only buffers
(setq kill-read-only-ok 1)

;; Partially integrate the kill-ring and X cut-buffer
;(setq x-select-enable-clipboard t)

;; Copy/paste with accentuation intact
(setq selection-coding-system 'compound-text-with-extensions)

;; Delete selection on a key press
(delete-selection-mode t)


(global-auto-revert-mode t)
;; }}}
;; }}}
