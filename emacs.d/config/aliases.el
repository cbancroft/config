;{{{ Alias some custom functions
;
(defalias 'search-web    'aic-web-search)
(defalias 'stamp         'aic-dotfile-stamp)
(defalias 'date-stamp    'aic-txtfile-stamp)
(defalias 'recode-buffer 'aic-recode-buffer)
(defalias 'encode-buffer 'aic-encode-buffer)
(defalias 'nuke          'aic-nuke-all-buffers)

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
