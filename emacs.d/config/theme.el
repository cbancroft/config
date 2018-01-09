;; Color theme initialization
;;   - http://emacswiki.org/cgi-bin/wiki/ColorTheme
;(require 'color-theme)
;(setq color-theme-is-global t)
;(color-theme-initialize)

;;
;; Load preferred theme
;;   - http://www.brockman.se/software/zenburn/zenburn.el
;;(color-theme-zenburn)
;;(color-theme-xoria256)
;;(load-theme 'warm-night)

(defvar cb/theme-loaded nil)

(defun cb/load-theme (frame)
  (when (not cb/theme-loaded)
    (select-frame frame)
    (set-frame-parameter frame 'background-mode 'dark)
    ;;    (setq solarized-termcolors 256)
    ;;    (enable-theme 'solarized)
        (load-theme 'monokai t)
    ;;(load-theme 'xoria256 t )
    (cb/mode-line-theme)
    (setq cb/theme-loaded t)))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'cb/load-theme)
  (cb/load-theme (selected-frame)))
