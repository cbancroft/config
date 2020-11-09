(require 'bbdb)

(bbdb-initialize 'gnus 'message)
(bbdb-insinuate-message)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)

(setq bbdb-file "~/.emacs.d/bbdb")


