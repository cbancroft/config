(require 'cc-mode)

(require 'google-c-style)
;; (add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; function-args
(require 'function-args)
(fa-config-default)

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
(setq company-backends (delete 'company-semantic company-backends))
(add-hook 'after-init-hook 'global-company-mode)
;; (delete 'company-semantic company-backends)
(define-key company-mode-map (kbd "C-;") 'company-complete)

;; company-c-headers
(add-to-list 'company-backends 'company-c-headers)

;; company-gtags
(add-to-list 'company-backends 'company-gtags)

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)

;;(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

(setq company-idle-delay .3
      company-minimum-prefix-length 2
      company-show-numbers 2
      company-tooltip-limit 20
      company-dabbrev-downcase nil)


;; Style
;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "linux" ;; set style to "linux"
 )

(global-set-key (kbd "C-c w") 'whitespace-mode)

;; Show unnecessary whitespace
(add-hook 'prog-hook-mode (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; Package: clean-aindent-road
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

;; Package: dtrt-indent
(require 'dtrt-indent)
(dtrt-indent-mode 1)

;; Package: ws-butler
(require 'ws-butler)
(add-hook 'prog-mode-hook 'ws-butler-mode)

;; Package: yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; Package: smartparens
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)

(show-smartparens-global-mode +1)
(smartparens-global-mode 1)


(require 'projectile)
(setq project-enable-caching t)
(setq projectile-indexing-method 'alien)

(require 'semantic)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)

;; (add-to-list 'company-backends 'company-semantic)
