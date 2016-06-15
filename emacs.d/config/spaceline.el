(require 'spaceline)
(require 'spaceline-config)

(defun cb/mode-line-theme ()
  (setq spaceline-workspace-numbers-unicode nil)

  (spaceline-define-segment line-column
    "The current line and column numbers."
    (if (eq major-mode 'pdf-view-mode)
	(concat (number-to-string (pdf-view-current-page))
		"/"
		(number-to-string (pdf-cache-number-of-pages)))
      mode-line-position
      "%l:%2c"))

  (spaceline-spacemacs-theme)
  (spaceline-helm-mode)
  (set-face-attribute 'powerline-active1 nil :background "grey10" :foreground "white smoke")
  (set-face-attribute 'powerline-active2 nil :background "grey22" :foreground "gainsboro")
  (set-face-attribute 'powerline-inactive1 nil :background "grey30" :foreground "white smoke")
  (set-face-attribute 'powerline-inactive2 nil :background "grey35" :foreground "gainsboro")
  (powerline-reset))
