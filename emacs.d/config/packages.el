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

;; EasyPG assistant (GPG mode)
(require 'epa)

;; Tramp (remote files editing)
(require 'tramp)
(setq tramp-default-method "ssh")

;; BBDB (contact management)
(require 'bbdb)
(bbdb-initialize)

;; SCPaste (scp pastebin)
;;   - http://www.emacswiki.org/cgi-bin/wiki/SCPaste
(autoload 'scpaste "scpaste" "Paste the current buffer." t nil)

;; Folding
;;   - http://www.emacswiki.org/emacs/FoldIngo
;; (require 'foldingo)

;; {{{ AUCTeX
;; From http://piotrkazmierczak.com/2010/05/13/emacs-as-the-ultimate-latex-editor/
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'latex-mode-hook 'turn-on-reftex)
;; }}}

;; {{{ Speedbar settings
(require 'speedbar)
;; Additional extensions we are interested in
(speedbar-add-supported-extension
  '("PKGBUILD" ".txt" ".org" ".pdf" ".css"
    ".php" ".conf" ".patch" ".diff" ".lua" ".sh")
)
;;}}}

;; {{{ Lua mode
;;    - http://lua-mode.luaforge.net/
;;
(autoload 'lua-mode "lua-mode" "Major-mode for editing lua scripts." t)
;; (setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
    (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
;; }}}

;; {{{ Markdown mode
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\.md$" . markdown-mode) auto-mode-alist))

;; }}}

(require 'yasnippet)
(yas-global-mode 1)

;; Markdown 
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Icomplete
;;   - completion in the mini-buffer
(icomplete-mode t)


;; Auto Compression
;;   - edit files in compressed archives
(auto-compression-mode 1)
