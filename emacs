;-*- coding: utf-8 -*-
; 
; anrxc's .emacs for GNU/Emacs 23.2 on Arch GNU/Linux
;Updated on: Apr 19, 06:52:05 EDT 2011

;{{{ Initialization
;
;; Define the load path
(setq load-path (cons "~/.emacs.d/" load-path))
;(setq load-path (cons "/usr/share/emacs/site-lisp" load-path))
;(setq load-path (cons "/usr/share/emacs/23.3/lisp" load-path))

;; Turn off the toolbar
(tool-bar-mode -1)
;;
;; Turn off the menu bar
(menu-bar-mode -1)
;;
;; Turn off the scrollbar
(scroll-bar-mode -1)
;}}}



;{{{ Look & Feel
;
;; Default font
;(set-default-font "-xos4-terminus-medium-r-normal-*-12-120-72-72-c-60-iso8859-2")


;; Color theme initialization
;;   - http://emacswiki.org/cgi-bin/wiki/ColorTheme
(require 'color-theme)
(setq color-theme-is-global t)
(color-theme-initialize)
(load "zenburn.el" )

;;
;; Load preferred theme
;;   - http://www.brockman.se/software/zenburn/zenburn.el
(color-theme-zenburn)

;; Support 256 colors in screen
;;   - http://article.gmane.org/gmane.emacs.devel/109504/
(if (not (window-system)) (load "term/rxvt"))
(defun terminal-init-screen ()
  "Terminal initialization function for screen."
  ;; Use the rxvt color initialization code.
  (rxvt-register-default-colors)
  (tty-set-up-initial-frame-faces)
)


;; Don't show the welcome message
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

;; Shut off message buffer
(setq message-log-max nil)
(kill-buffer "*Messages*")

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
(setq browse-url-browser-function 'browse-url-firefox)

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
;;
;; Wrap lines at 70 in text-mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;;
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

;; Accelerate the cursor when scrolling
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
;}}}
;}}}



;{{{ Settings for various modes
;    - major modes for editing code and other formats are defined below
;
;; IDO (interactive buffer and file management)
(require 'ido)
(ido-mode t)
(setq
  ido-save-directory-list-file "~/.emacs.d/emacs-ido-last"
  ;ido-work-directory-list '("~/" "~/Docs" "~/Work")
  ido-ignore-buffers               ; Ignore buffers:
    '("\\` " "^\*Back" "^\*Compile-Log" ".*Completion" "^\*Ido")
  ;ido-confirm-unique-completion t ; Wait for RET, even on unique
  ido-everywhere t                 ; Enabled for various dialogs
  ido-case-fold  t                 ; Case-insensitive
  ido-use-filename-at-point nil    ; Don't use filename at point
  ido-use-url-at-point nil         ; Don't use url at point
  ido-enable-flex-matching t       ; More flexible
  ido-max-prospects 6              ; Keep minibuffer clean
)


;; EasyPG assistant (GPG mode)
(require 'epa)

;; Ledger mode
(require 'ledger)

;; Tramp (remote files editing)
(require 'tramp)
(setq tramp-default-method "ssh")

;; BBDB (contact management)
(require 'bbdb)
(bbdb-initialize)

;; Egg (git interface)
;;   - http://github.com/bogolisk/egg
(require 'egg)
;; Enable tooltips while we are still learning
(setq egg-enable-tooltip t)


;; SCPaste (scp pastebin)
;;   - http://www.emacswiki.org/cgi-bin/wiki/SCPaste
(autoload 'scpaste "scpaste" "Paste the current buffer." t nil)


;; Linum (line numbering)
(require 'linum)
;; - do not enable by default, breaks org-mode
;(global-linum-mode)


;; Folding
;;   - http://www.emacswiki.org/emacs/FoldIngo
;; (require 'foldingo)


;; Ediff
;;
;; Don't spawn a new frame
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; Split the frame horizontally
(setq ediff-split-window-function 'split-window-horizontally)


;; Saveplace
;;   - places cursor in the last place you edited file
(require 'saveplace)
(setq-default save-place t)
;; Keep places in the load path
(setq save-place-file "~/.emacs.d/emacs-places")


;; Uniquify
;;   - makes buffer names unique
(require 'uniquify)
(setq uniquify-separator ":")
(setq uniquify-buffer-name-style 'post-forward)


;; Icomplete
;;   - completion in the mini-buffer
(icomplete-mode t)


;; Auto Compression
;;   - edit files in compressed archives
(auto-compression-mode 1)


;; Speedbar settings
(require 'speedbar)
;; Additional extensions we are interested in
(speedbar-add-supported-extension
  '("PKGBUILD" ".txt" ".org" ".pdf" ".css"
    ".php" ".conf" ".patch" ".diff" ".lua" ".sh")
)
;}}}



;{{{ Custom functions

;{{{ Web search, browser defined earlier
;    - yubnub: a (social) commandline for the web
;
(defun aic-web-search ()
  "Prompt for a web search query in the minibuffer."
  (interactive)
  (let ((search (read-from-minibuffer "Search: ")))
    (browse-url (concat "http://www.yubnub.org/parser/parse?command=" search)))
)
;}}}

;{{{ Timestamp function, for public dotfiles
;    - date-stamp is more appropriate for txt files
;
(defun aic-dotfile-stamp ()
  "Insert time stamp at point."
  (interactive)
  (insert "Updated on: " (format-time-string "%b %e, %H:%M:%S %Z %Y" nil nil))
)
(defun aic-txtfile-stamp ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%d.%m.%Y %H:%M"))
)
;}}}

;{{{ Reload or edit .emacs on the fly
;    - key bindings defined below
;
(defun aic-reload-dot-emacs ()
  "Reload user configuration from .emacs"
  (interactive)
  ;; Fails on killing the Messages buffer, workaround:
  (get-buffer-create "*Messages*")
  (load-file "~/.emacs")
)
(defun aic-edit-dot-emacs ()
  "Edit user configuration in .emacs"
  (interactive)
  (find-file "~/.emacs")
)
;}}}

;{{{ Quick access to ansi-term
;    - key binding defined below
;
(defun aic-visit-ansi-term ()
  "If we are in an *ansi-term*, rename it.
If *ansi-term* is running, switch the buffer.
If there is no *ansi-term*, run it."
  (interactive)
  (if (equal "*ansi-term*" (buffer-name))
      (call-interactively 'rename-buffer)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
  (ansi-term "/bin/zsh")))
)
;}}}

;{{{ Quick acces to coding functions
;    - I deal with utf8, latin-2 and cp1250
;
(defun aic-recode-buffer ()
  "Define the coding system for a file."
  (interactive)
  (call-interactively 'set-buffer-file-coding-system)
)
(defun aic-encode-buffer ()
  "Revisit the buffer with another coding system."
  (interactive)
  (call-interactively 'revert-buffer-with-coding-system)
)
;}}}

;{{{ Kill all buffers except scratch
;
(defun aic-nuke-all-buffers ()
  "Kill all buffers, leaving *scratch* only."
  (interactive)
  (mapcar (lambda (x) (kill-buffer x)) (buffer-list))
  (delete-other-windows)
)
;}}}

;{{{ Quick access to OrgMode and the OrgMode agenda
;    - org-mode configuration defined below
;
(defun aic-org-index ()
   "Show the main org file."
   (interactive)
   (find-file "~/.org/index.org")
)
(defun aic-org-agenda ()
  "Show the org-mode agenda."
  (interactive)
  (call-interactively 'org-agenda-list)
)
;}}}

;{{{ Alias some custom functions
;
(defalias 'search-web    'aic-web-search)
(defalias 'stamp         'aic-dotfile-stamp)
(defalias 'date-stamp    'aic-txtfile-stamp)
(defalias 'recode-buffer 'aic-recode-buffer)
(defalias 'encode-buffer 'aic-encode-buffer)
(defalias 'nuke          'aic-nuke-all-buffers)
(defalias 'org           'aic-org-index)
;}}}

;{{{ Shortcut a few commonly used functions
;
(defalias 'cr            'comment-region)
(defalias 'ucr           'uncomment-region)
(defalias 'eb            'eval-buffer)
(defalias 'er            'eval-region)
(defalias 'ee            'eval-expression)
(defalias 'day           'color-theme-vim-colors)
(defalias 'night         'color-theme-zenburn)
(defalias 'fold          'fold-enter-fold-mode-close-all-folds)
;}}}
;}}}



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
(global-set-key "\C-cs" 'speedbar-get-focus)

;; org-mode bindings for quick access (see below)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cr" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)

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
;}}}

;{{{ Fn bindings
;
(global-set-key  [f1]  (lambda () (interactive) (manual-entry (current-word))))
(global-set-key  [f2]  (lambda () (interactive) (find-file org-default-notes-file)))
(global-set-key  [f3]  'aic-org-agenda)           ; Function defined previously
(global-set-key  [f4]  'aic-visit-ansi-term)      ; Function defined previously
;(global-set-key [f5]  'aic-fold-toggle-fold)     ; Todo: Toggle all folds
(global-set-key  [f5]  'org-show-todo-tree)       ; Show todo tree
(global-set-key  (kbd "<f6> l")  'linum-mode)     ; Toggle line numbering
(global-set-key  (kbd "<f6> c")  'calendar)       ; Toggle calendar
(global-set-key  (kbd "<f6> I")  'cb/clock-in)    ; Clock in
(global-set-key  (kbd "<f6> O")  'cb/clock-out)   ; Clock out
(global-set-key  (kbd "<f6> h")  'cb/hide-other)  ; Hide other windows?
(global-set-key  (kbd "<f6> i")  'cb/org-info)    ; Get info on org
(global-set-key  [f7]  'htmlfontify-buffer)
(global-set-key  [f8]  'ispell-buffer)
(global-set-key  [f9]  'ispell-change-dictionary) ; Switching 'en_US' and 'hr' often
;(global-set-key [f10]                            ; Quick menu by default

(global-set-key  [f11] 'speedbar)
(global-set-key  [f12] 'kill-buffer)
;}}}
;}}}


;{{{ OrgMode
;   - http://www.emacswiki.org/emacs/OrgMode
;
;; Initialization
(add-to-list 'load-path "~/.emacs.d/org")
(require 'org-install)
(require 'cl)
;;
;; Extended mouse functionality
(load "org-mouse.el")

;; Settings
(setq org-directory "~/org/")
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;; Misc
(setq org-log-done t)
(setq org-completion-use-ido t)
(setq org-return-follows-link t)
(setq org-use-fast-todo-selection t)
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))

; Targetss include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel .5))))

; Targetss start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))

; Targets compleete in steps so we start with filename, TAB shows next level of targets, etc
(setq org-outline-path-complete-in-steps t)

; Allow refile to create parent takss with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))


;; Create structured email messages from Gnus
(setq message-mode-hook
      (quote (orgstruct++-mode
	      (lambda nil (setq fill-column 72) (flyspell-mode 1))
	      turn-on-auto-fill
	      bbdb-define-all-aliases)))

;; Pass mailto links to Alpine instead of browse-url
(setq org-link-mailto-program 
 '(shell-command "urxvtc -title Alpine -e alpine -url 'mailto:%a?Subject=%s'")
)

;; Files that are included in org-mode agenda
(setq org-agenda-files
 (quote ("~/org/home.org"
	 "~/org/todo.org"
	 "~/org/refile.org"
	 "~/org/work.org")))

;; Task sequence
(setq org-todo-keywords (quote ((sequence "TODO(t!)" "NEXT(n!)" "|" "DONE(d!/!)")
				(sequence "WAITING(w@/!)" "SOMEDAY(s!)" "|" "CANCELLED(c@/!)")
				(sequence "OPEN(O!)" "|" "CLOSED(C!)"))))

;; Bold the TODO keywords
(setq org-todo-keyword-faces
      (quote (("TODO"			:foreground "red"		:weight bold)
	      ("NEXT"			:foreground "blue"		:weight bold) 
	      ("DONE"			:foreground "forest green"	:weight bold)
	      ("WAITING"		:foreground "yellow"		:weight bold)
	      ("SOMEDAY"		:foreground "goldenrod"		:weight bold)
	      ("CANCELLED"		:foreground "orangered"		:weight bold)
	      ("OPEN"			:foreground "magenta"		:weight bold)
	      ("CLOSED"			:foreground "forest green"	:weight bold))))
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED"
	       ("CANCELLED" . t ))
	      ("WAITING"
	       ("WAITING" . t ))
	      ("SOMEDAY"
	       ("SOMEDAY" . t))
	      (done
	       ("WAITING"))
	      ("TODO"
	       ("WAITING")
	       ("CANCELLED"))
	      ("NEXT"
	       ("WAITING"))
	      ("DONE"
	       ("WAITING")
	       ("CANCELLED")))))

(defun cb/clock-in ()
  (interactive)
  (setq  cb/keep-clock-running t)
  (org-agenda  nil "c"))

(defun cb/clock-out ()
  (interactive)
  (setq cb/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out)))

(defun cb/hide-other ()
  (interactive)
  (save-excursion
    (org-back-to-heading)
    (org-shifttab)
    (org-reveal)
    (org-cycle)))

(defun cb/clock-in-to-next (kw)
  "Switch task from TODO to NEXT when clocking in.
Skips capture tasks and tasks with no subtasks"
  (if (and (string-equal kw "TODO")
	   (not (and (boundp 'org-capture-mode) org-capture-mode)))
      (let ((subtree-end (save-excursion (org-end-of-subtree t)))
	    (has-subtask nil))
	(save-excursion
	  (forward-line 1)
	  (while (and (not has-subtask)
		      (< (point) subtree-end)
		      (re-search-forward "^\*+ " subtree-end t))
	    (when (member (org-get-todo-state) org-not-done-keywords)
	      (setq has-subtask t))))
	(when (not has-subtask)
	  "NEXT"))))

(defun cb/org-info ()
  (interactive)
  (info "org"))
;}}}


;{{{ Capture mode
;   - connected with org-mode
;
;; Initialization
;; (require 'capture)

;;
;; Notes file
(setq org-default-notes-file (concat org-directory "/refile.org"))
;
;; Templates for Notes
(setq org-capture-templates
      '(
	("t" "Todo"	entry (file+headline org-default-notes-file "Todo")	"* TODO %?\n%U\n%a"  :clock-in t :clock-resume t)
	("n" "Note"     entry (file+headline org-default-notes-file "Notes")	"* NOTE %?    :NOTE:\n%i\n%a\n:CLOCK:\n:END:" :clock-in t :clock-resume t)
	("a" "apptmt"	entry (file+datetree "~/org/diary.org" "Appointment")	"* APPT %?\n%U" :clock-in t :clock-ressume t)
	("d" "Download" entry (file+headline "~/org/notes.org" "Download") "* DL %?\n%i\n%a" )
	("l" "Login"    entry (file+headline "~/org/notes.org" "Logins") "* LOGIN %?\n%i\n%a")
	("m" "Music"    entry (file+headline "~/org/notes.org" "Music") "* MUSIC %?\n%i\n%a")
	("i" "Idea"     entry (file+headline "~/org/notes.org" "Brainstorm") "* %^{Title}\n%i\n%a" )
	("c" "Clipboard" entry (file+headline "~/org/notes.org" "Clipboard") "* %^{Description} %TT\n%x" ))
)

;;Remove empty clock drawers on clock out
(defun cb/remove-empty-clock-drawers-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "CLOCK" (point))))
(add-hook  'org-clock-out-hook  'cb/remove-empty-clock-drawers-on-clock-out 'append)

;; Remember frames
;;   - $ emacsclient -e '(make-remember-frame)'
;;
;; Org-remember splits windows, force it to a single window
(add-hook 'capture-mode-hook  'delete-other-windows)

;; Automatic closing of remember frames
(defadvice capture-finalize (after delete-capture-frame activate)
  "Advise remember-finalize to close the frame if it is the remember frame"
  (if (equal "*Remember*" (frame-parameter nil 'name))
    (delete-frame))
)
(defadvice capture-destroy (after delete-capture-frame activate)
  "Advise remember-destroy to close the frame if it is the remember frame"
  (if (equal "*Remember*" (frame-parameter nil 'name))
    (delete-frame))
)

;; Initialization of remember frames
(defun make-capture-frame ()
  "Create a new frame and run org-remember"
  (interactive)  
  (make-frame '((name . "*Capture*") (width . 80) (height . 10)))
  (select-frame-by-name "*Capture*")
  (org-capture)
)
;}}}


;=====================================================================
;{{{  Email
(setq smtpmail­smtp­server "mail.bbn.com")
(setq send­mail­function 'smtpmail­send­it)
(setq message­send­mail­function 'smtpmail­send­it)
(require 'smtpmail)
;}}}  Email
;=====================================================================

;{{{ Calendar settings
;
(setq
  holidays-in-diary-buffer               t
  mark-holidays-in-calendar              t
  all-christian-calendar-holidays        t
  all-islamic-calendar-holidays        nil
  all-hebrew-calendar-holidays         nil
  european-calendar-style                t
  ;display-time-24hr-format              t
  display-time-day-and-date            nil
  ;display-time-format                 nil
  ;display-time-use-mail-icon          nil
  calendar-latitude                  43.30
  calendar-longitude                -70.98
  calendar-location-name "Rochester, NH, USA"
)
;}}}



;{{{ Major modes for editing code and other formats

;{{{ Custom modes for some custom files
;
;; Shell script mode for Arch PKGBUILDs
(setq auto-mode-alist (cons '("\\PKGBUILD$" . sh-mode) auto-mode-alist))
;;
;; Conf mode for personal config files
(when (locate-library "conf-mode")
  (autoload 'conf-mode "conf-mode" "Major-mode for editing config files." t)
  (add-to-list 'auto-mode-alist '("\\awesomerc$" . conf-mode))
  (add-to-list 'auto-mode-alist '("\\gitconfig$" . conf-mode))
  (add-to-list 'auto-mode-alist '("\\screenrc$"  . conf-mode))
  (add-to-list 'auto-mode-alist '("\\pinerc$"    . conf-mode))
)
;}}}

;{{{ Python mode
;
;; ipython is my shell of choice, glad to have it here
(defcustom python-python-command "ipython -cl"
  "Shell command to run Python interpreter."
  :group 'python
  :type 'string
)
;}}}

;{{{ Lua mode
;    - http://lua-mode.luaforge.net/
;
(autoload 'lua-mode "lua-mode" "Major-mode for editing lua scripts." t)
;(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
    (autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;}}}

;{{{ Crontab mode
;    - http://www.mahalito.net/~harley/elisp/crontab-mode.el
;
(autoload 'crontab-mode "~/.emacs.d/crontab-mode.el" "Major mode for editing the crontab" t)
(add-to-list 'auto-mode-alist '("cron\\(tab\\)?\\."   . crontab-mode))
;}}}

;{{{ Post mode
;    - http://post-mode.sourceforge.net/
;
(autoload 'post-mode "~/.emacs.d/post.el" "Major mode for editing e-mail and journal articles" t)
(add-to-list 'auto-mode-alist 
  '("\\.*mutt-*\\|\\.*pico.*\\|.article\\|\\.*200\\(T\\)?\\|\\.followup" . post-mode))
;}}}
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/org/deter.org" "~/org/home.org" "~/org/todo.org" "~/org/refile.org" "~/org/work.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
