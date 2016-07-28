(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'cl)
(require 'org)
(require 'helm-org)
(require 'org-magit)
(require 'bbdb)
(require 'bbdb-com)
(require 'ox-odt)
;; {{{ Variables
;; Agenda files
(setq org-agenda-files (quote ("~/git/org-files"
			       "~/git/org-files/siege")))

;; Set org directories
(setq org-directory "~/git/org-files")
(setq org-default-notes-file "~/git/org-files/refile.org")

;; Enable fast todo selection
(setq org-use-fast-todo-selection t)

;; Change on S-Left and S-Right without having to set notes
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

;; Start in folded view
(setq org-startup-folded t)

(setq org-reverse-note-order nil)

;; Want to highlight code block in their native syntax
(setq org-src-fontify-natively t)

;; Force showing the next headline
(setq org-show-entry-below (quote ((default))))

;; Limit restriction lock highlighting to the headline only
(setq org-agenda-restriction-lock-highlight-subtree nil)

;; Start with indent mode
(setq org-startup-indented t)

;; Follow links when RET key is hit
(setq org-return-follows-link t)

;; Export ODT to docx by Default
(setq org-odt-preferred-output-format "pdf")
; Enable habit tracking (and a bunch of other modules)
(setq org-modules (quote (org-bbdb
                          org-bibtex
                          org-crypt
                          org-gnus
                          org-id
                          org-info
                          org-jsinfo
                          org-habit
                          org-inlinetask
                          org-irc
                          org-mew
                          org-mhe
                          org-protocol
                          org-rmail
                          org-vm
                          org-wl
                          org-w3m)))

(defvar cb/hide-scheduled-and-waiting-next-tasks t)
(defvar cb/projet-list nil)

(setq org-link-frame-setup (quote ((vm . vm-visit-folder)
                                   (gnus . org-gnus-no-new-news)
                                   (file . find-file))))

; Use the current window for C-c ' source editing
(setq org-src-window-setup 'current-window)
;; }}}

;; {{{ Key Bindings
;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "<f5>" ) 'cb/org-todo)
(global-set-key (kbd "<S-f5>") 'cb/widen)
(global-set-key (kbd "<f8>" ) 'org-cycle-agenda-files)
(global-set-key (kbd "<f9> <f9>") 'cb/show-org-agenda)
(global-set-key (kbd "<f9> b") 'bbdb)
(global-set-key (kbd "<f9> c") 'calendar)
(global-set-key (kbd "<f9> m") 'mu4e)
(global-set-key (kbd "<f9> o") 'cb/hide-other)
(global-set-key (kbd "<f9> n") 'cb/toggle-next-task-display)
(global-set-key (kbd "<f9> p") 'cb/phone-call)

(global-set-key (kbd "<f9> I") 'cb/punch-in)
(global-set-key (kbd "<f9> O") 'cb/punch-out)

(global-set-key (kbd "<f9> o") 'cb/make-org-scratch)
(global-set-key (kbd "<f9> s") 'cb/switch-to-scratch)

(global-set-key (kbd "<f9> t") 'cb/insert-inactive-timestamp)
(global-set-key (kbd "<f9> T") 'cb/toggle-insert-inactive-timestamp)

(global-set-key (kbd "<f9> v") 'visible-mode)
(global-set-key (kbd "<f9> l") 'org-toggle-link-display)
(global-set-key (kbd "<f9> SPC") 'cb/clock-in-last-task)
(global-set-key (kbd "C-<f9>") 'previous-buffer)
(global-set-key (kbd "<S-f9>") 'next-buffer)
(global-set-key (kbd "<f11>") 'org-clock-goto)
(global-set-key (kbd "C-<f11>") 'org-clock-in)
(global-set-key (kbd "C-c c") 'org-capture)
;; }}}

;; {{{ TODO stuff
;; TODO state keywords
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

;; TODO state change triggers
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t)) ;Add cancelled when switching to CANCELLED state
	      ("WAITING"   ("WAITING" . t))   ;Add WAITING when switching to WAITING state
	      ("HOLD"      ("WAITING") ("HOLD" . t)) ;Remove WAITING and add HOLD to HOLD states
	      (done        ("WAITING") ("HOLD")) ;Remove WAITING and HOLD when done
	      ("TODO"      ("WAITING") ("CANCELLED") ("HOLD")) ;Remove other tags on TODO,NEXT,DONE
	      ("NEXT"      ("WAITING") ("CANCELLED") ("HOLD"))
	      ("DONE"      ("WAITING") ("CANCELLED") ("HOLD")))))
;; }}}

;; {{{ Capture mode stuff
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/git/org-files/refile.org")
	       "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("r" "respond" entry (file "~/git/org-files/refile.org")
	       "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("n" "note" entry (file "~/git/org-files/refile.org")
	       "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("i" "interruption" entry (file "~/git/org-files/diary.org")
	       "* %?\n%U\n" :clock-in t :clock-resume t)
	      ("j" "journal entry" plain (file+datetree "~/git/org-files/journal.org")
	       "%i\n%?\n" :unnarrowed t)
	      ("m" "Meeting" entry (file "~/git/org-files/refile.org")
	       "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
	      ("N" "task Note" plain (clock)
	       "\n%?\n" :unnarrowd t)
	      ("p" "Phone call" entry (file "~/git/org-files/refile.org")
	       "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
	      ("h" "Habit" entry (file "~/git/org-files/refile.org")
	       "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
;; }}}

;; {{{ Refile stuff
;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
				 (org-agenda-files :maxlevel . 9))))

;; Use full outline paths for refile targets -- file directly with ido
(setq org-refile-use-outline-path t)

;; Targets complete in ido
(setq org-outline-path-complete-in-steps nil)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

;; Use IDO for both file completion and ido-everywhere to t
(setq org-completion-handler 'helm)


;; Exclude done state tasks from refile
(defun cb/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'cb/verify-refile-target)
;; }}}

;; {{{ Agenda Views

;; Only show today by default
(setq org-agenda-span 'day)

;; Disable default stuck projects agenda view
(setq org-stuck-projects (quote ("" nil nil "")))

;; Don't dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

; position the habit graph on the agenda to the right of the default
(setq org-habit-graph-column 50)

;; skip multiple timestamps for the same entry.
(setq org-agenda-skip-additional-timestamps-same-entry t)

;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)

;; Show all agenda dates - even if they are empty
(setq org-agenda-show-all-dates t)

;; Sorting order for tasks on the agenda
(setq org-agenda-sorting-strategy
      (quote ((agenda habit-down time-up user-defined-up effort-up category-keep)
	      (todo category-up effort-up)
	      (tags category-up effort-up)
	      (search category-up))))

;;; Start the weekly agenda on Monday
(setq org-agenda-start-on-weekday 1)

;; Enable display of the time grid so we can see the marker for the current line
(setq org-agenda-time-grid (quote ((daily today remove-match)
				   #("----------------" 0 16 (org-heading t))
				   (0900 1100 1300 1500 1700))))

;; Display tags farther right
(setq org-agenda-tags-column -102)


;; Agenda sorting function
(setq org-agenda-cmp-user-defined 'cb/agenda-sort)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
	       ((org-agenda-overriding-header "Notes")
		(org-tags-match-list-sublevels t)))
	      ("h" "Habits" tags-todo "STYLE=\"habit\""
	       ((org-agenda-overriding-header "Habits")
		(org-agenda-sorting-strategy
		 '(todo-state-down effort-up category-keep))))
	      (" " "Agenda"
	       ((agenda "" nil)
		(tags "REFILE"
		      ((org-agenda-overriding-header "Tasks to Refile")
		       (org-tags-match-list-sublevels nil)))
		(tags-todo "-CANCELLED/!"
			   ((org-agenda-overriding-header "Stuck Projects")
			    (org-agenda-skip-function 'cb/skip-non-stuck-projects)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-HOLD-CANCELLED/!"
			   ((org-agenda-overriding-header "Projects")
			    (org-agenda-skip-function 'cb/skip-non-projects)
			    (org-tags-match-sublevels 'indented)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-CANCELLED/!NEXT"
			   ((org-agenda-overriding-header (concat "Project Next Tasks"
								  (if cb/hide-scheduled-and-waiting-next-tasks
                                                                      ""
                                                                    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'cb/skip-projects-and-habits-and-single-tasks)
			    (org-tags-match-list-sublevels t)
			    (org-agenda-todo-ignore-scheduled cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(todo-state-down effort-up category-keep))))
		(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
			   ((org-agenda-overriding-header (concat "Project Subtasks"
								  (if cb/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'cb/skip-non-project-tasks)
			    (org-agenda-todo-ignore-scheduled cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
			   ((org-agenda-overriding-header (concat "Standalone Tasks"
								  (if cb/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'cb/skip-project-tasks)
			    (org-agenda-todo-ignore-scheduled cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-CANCELLED+WAITING|HOLD/!"
			   ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
								  (if cb/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'cb/skip-non-tasks)
			    (org-tags-match-list-sublevels nil)
			    (org-agenda-todo-ignore-scheduled cb/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines cb/hide-scheduled-and-waiting-next-tasks)))
		(tags "-REFILE/"
		      ((org-agenda-overriding-header "Tasks to Archive")
		       (org-agenda-skip-function 'cb/skip-non-archivable-tasks)
		       (org-tags-match-list-sublevels nil))))
	       nil))))

;; }}}

;; {{{Speed Commands
(setq org-use-speed-commands t)
(setq org-speed-commands-user (quote (("0" . ignore)
                                      ("1" . ignore)
                                      ("2" . ignore)
                                      ("3" . ignore)
                                      ("4" . ignore)
                                      ("5" . ignore)
                                      ("6" . ignore)
                                      ("7" . ignore)
                                      ("8" . ignore)
                                      ("9" . ignore)

                                      ("a" . ignore)
                                      ("d" . ignore)
                                      ("i" progn
                                       (forward-char 1)
                                       (call-interactively 'org-insert-heading-respect-content))
                                      ("k" . org-kill-note-or-show-branches)
                                      ("l" . ignore)
                                      ("m" . ignore)
                                      ("q" . cb/show-org-agenda)
                                      ("r" . ignore)
                                      ("s" . org-save-all-org-buffers)
                                      ("w" . org-refile)
                                      ("x" . ignore)
                                      ("y" . ignore)
                                      ("z" . org-add-note)

                                      ("A" . ignore)
                                      ("B" . ignore)
                                      ("E" . ignore)
                                      ("G" . ignore)
                                      ("H" . ignore)
                                      ("J" . org-clock-goto)
                                      ("K" . ignore)
                                      ("L" . ignore)
                                      ("M" . ignore)
                                      ("Q" . ignore)
                                      ("R" . ignore)
                                      ("S" . ignore)
                                      ("V" . ignore)
                                      ("X" . ignore)
                                      ("Y" . ignore)
                                      ("Z" . ignore))))
;; }}}

;; {{{ Log settings
(setq org-log-done (quote time))
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)
;; }}}
;; {{{ Archive settings
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")
;; }}}
;; {{{ Clocking
;; Resume clocking tasks when emacs is restarted
(org-clock-persistence-insinuate)

;;Show a lot of clocking history so it is easy to pick items off the C-F11 list
(setq org-clock-history-length 23)

;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)

;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'cb/clock-in-to-next)

;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))

;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)

;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Clock out when moving tasks to the DONE state
(setq org-clock-out-when-done t)

;; Save the running clock and all clock history when exiting emacs, load it on startup
(setq org-clock-persist t)

;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)

;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))

;;Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq cb/keep-clock-running nil)

;; Agenda log mode items to display (closed and state changes by default)
(setq org-agenda-log-mode-items (quote (closed state)))

(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
              :min-duration 0
              :max-gap 0
              :gap-ok-around ("4:00"))))

;;Clock is inverted??
(custom-set-faces
 '(org-mode-line-clock ((t (:background "grey75" :foreground "red"
					:box (:line-width -1 :style
							  released-button))))
		       t))

;; }}}

;; {{{ Tags
;; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
			    ("@errand" . ?e)
			    ("@office" . ?o)
			    ("@home" . ?H)
			    (:endgroup)
			    ("WAITING" . ?w)
			    ("HOLD" . ?h)
			    ("PERSONAL" . ?P)
			    ("WORK" . ?W)
			    ("NOTE" . ?n)
			    ("CANCELLED" . ?c)
			    ("FLAGGED" . ??))))

;; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

;; For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)
			     
;; }}}
;; {{{ Effort Estimation
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
				    ("STYLE_ALL" . "habit"))))
;; }}}
;; {{{ Functions
;; Remove empty logbook drawers on clock out
(defun cb/remove-empty-clock-drawers-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at (point))))

(defun cb/org-auto-exclude-function (tag)
  "Automatic task exclusion in the agenda with / RET"
  (and (cond
	((string= tag "hold")
	 t))
	(concat "-" tag)))
(setq org-agenda-auto-exclude-function 'cb/org-auto-exclude-function)

(defun cb/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojets.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
	   (cb/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
	   (cb/is-project-p))
      "TODO"))))

(defun cb/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun cb/punch-in (arg)
  "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
  (interactive "p")
  (setq cb/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in Agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-clock-hd-marker))
	     (tags (org-with-point-at marker (org-get-tags-at))))
	(if (and (eq arg 4) tags)
	    (org-agenda-clock-in '(16))
	  (cb/clock-in-organization-task-as-default)))
    ;;
    ;; Not in Agenda
    ;;
    (save-restriction
      (widen)
      ;; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
	  (org-clock-in '(16))
	(cb/clock-in-organization-task-as-default)))))

(defun cb/punch-out ()
  (interactive)
  (setq cb/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun cb/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun cb/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
	(widen)
	(while (and (not parent-task) (org-up-heading-safe))
	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	    (setq parent-task (point))))
	(if parent-task
	    (org-with-point-at parent-task
	      (org-clock-in))
	  (when cb/keep-clock-running
	    (cb/clock-in-default-task)))))))

(defvar cb/organization-task-id "7f2d38a5-19ad-40cf-afd2-18d357c9e286")

(defun cb/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find cb/organization-task-id 'marker)
    (org-clock-in '(16))))

(defun cb/clock-out-maybe ()
  (when (and cb/keep-clock-running
	     (not org-clock-clocking-in)
	     (marker-buffer org-clock-default-task)
	     (not org-clock-resolving-clocks-due-to-idleness))
    (cb/clock-in-parent-task)))

(defun cb/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
	  (subtree-end (save-excursion (org-end-of-subtree t)))
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(forward-line 1)
	(while (and (not has-subtask)
		    (< (point) subtree-end)
		    (re-search-forward "^\*+ " subtree-end t))
	  (when (member (org-get-todo-state) org-todo-keywords-1)
	    (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun cb/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
			      (point))))
    (save-excursion
      (cb/find-project-task)
      (if (equal (point) task)
	  nil
	t))))

(defun cb/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
	  (subtree-end (save-excursion (org-end-of-subtree t)))
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(forward-line 1)
	(while (and (not has-subtask)
		    (< (point) subtree-end)
		    (re-search-forward "^\*+ " subtree-end t))
	  (when (member (org-get-todo-state) org-todo-keywords-1)
	    (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun cb/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
	(is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
	(while (and (not is-subproject) (org-up-heading-safe))
	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	    (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun cb/list-sublevels-for-projects-indented ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
This is normally used by skipping functions where this variable is already local to the
agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels 'indented)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun cb/list-sublevels-for-projects ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
This is normally used by skipping functions where this variable is already local to the
agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels t)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun cb/toggle-next-task-display ()
  (interactive)
  (setq cb/hide-scheduled-and-waiting-next-tasks (not cb/hide-scheduled-and-waiting-next-tasks))
  (when (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if cb/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

(defun cb/skip-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (cb/is-project-p)
	  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		 (has-next ))
	    (save-excursion
	      (forward-line 1)
	      (while (and (not has-next)
			  (< (point) subtree-end)
			  (re-search-forward "^\\*+ NEXT" subtree-end t))
		(unless (member "WAITING" (org-get-tags-at))
		  (setq has-next t))))
	    (if has-next
		nil
	      next-headline)) ; a stuck project.  Has subtasks but no NEXT task
	nil))))

(defun cb/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (cb/is-project-p)
	  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		 (has-next ))
	    (save-excursion
	      (forward-line 1)
	      (while (and (not has-next)
			  (< (point) subtree-end)
			  (re-search-forward "^\\*+ NEXT " subtree-end t))
		(unless (member "WAITING" (org-get-tags-at))
		  (setq has-next t))))
	    (if has-next
		next-headline
	      nil)) ; a stuck project. Has subtasks but no NEXT task
	next-headline))))

(defun cb/skip-non-projects ()
  "Skip trees that are not projects."
  (if (save-excursion (cb/skip-non-stuck-projects))
      (save-restriction
	(widen)
	(let ((subtree-end (save-excursion (org-end-of-subtree t))))
	  (cond
	   ((cb/is-project-p)
	    nil)
	   ((and (cb/is-project-subtree-p) (not (cb/is-task-p)))
	    nil)
	   (t
	    subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun cb/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((cb/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       (t
	nil)))))

(defun cb/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits and
single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
	next-headline)
       ((and cb/hide-scheduled-and-waiting-next-tasks
	     (member "WAITING" (org-get-tags-at)))
	next-headline)
       ((cb/is-project-p)
	next-headline)
       ((and (cb/is-task-p) (not (cb/is-project-subtree-p)))
	next-headline)
       (t
	nil)))))

(defun cb/skip-project-tasks-maybe ()
  "Show tasks related to the current restriction
When restricted to a project, skip project and subproject tasks, habits, etc.
When not restricted, skip the project, subproject tasks, habits and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	   (next-headline (save-excursion (or (outline-next-heading) (point-max))))
	   (limit-to-project (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((cb/is-project-p)
	next-headline)
       ((org-is-habit-p)
	subtree-end)
       ((and (not-limit-to-project)
	     (cb/is-project-subtree-p))
	subtree-end)
       ((and limit-to-project
	     (cb/is-project-subtree-p)
	     (member (org-get-todo-state) (list "NEXT")))
	subtree-end)
       (t
	nil)))))

(defun cb/skip-project-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((cb/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       ((cb/is-project-subtree-p)
	subtree-end)
       (t
	nil)))))

(defun cb/skip-non-project-tasks ()
  "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
           (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((cb/is-project-p)
        next-headline)
       ((org-is-habit-p)
        subtree-end)
       ((and (cb/is-project-subtree-p)
             (member (org-get-todo-state) (list "NEXT")))
        subtree-end)
       ((not (cb/is-project-subtree-p))
        subtree-end)
       (t
        nil)))))

(defun cb/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((cb/is-project-p)
        subtree-end)
       ((org-is-habit-p)
        subtree-end)
       (t
        nil)))))

(defun cb/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (cb/is-subproject-p)
        nil
      next-headline)))

(defun cb/show-org-agenda ()
  (interactive)
  (if org-agenda-sticky
      (switch-to-buffer "*Org Agenda( )*")
    (switch-to-buffer "*Org Agenda*"))
  (delete-other-windows))

(defun cb/skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (save-restriction
    (widen)
    ;; Consider only tasks with done todo headings as archivable candidates
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
          (subtree-end (save-excursion (org-end-of-subtree t))))
      (if (member (org-get-todo-state) org-todo-keywords-1)
          (if (member (org-get-todo-state) org-done-keywords)
              (let* ((daynr (string-to-int (format-time-string "%d" (current-time))))
                     (a-month-ago (* 60 60 24 (+ daynr 1)))
                     (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
                     (this-month (format-time-string "%Y-%m-" (current-time)))
                     (subtree-is-current (save-excursion
                                           (forward-line 1)
                                           (and (< (point) subtree-end)
                                                (re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
                (if subtree-is-current
                    subtree-end ; Has a date in this month or last month, skip it
                  nil))  ; available to archive
            (or subtree-end (point-max)))
        next-headline))))

(defun org-clocktable-indent-string (level)
  (if (= level 1)
      ""
    (let ((str "\\__"))
      (while (> level 2)
        (setq level (1- level)
              str (concat str "___")))
      (concat str " "))))

(defun cb/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one. 
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
	 (cond
	  ((eq arg 4) org-clock-default-task)
	  ((and (org-clock-is-active)
		(equal org-clock-default-task (cadr org-clock-history)))
	   (caddr org-clock-history))
	  ((org-clock-is-active) (cadr org-clock-history))
	  ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
	  (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

(defun cb/phone-call ()
    "Return name and company info for caller from bbdb lookup"
    (interactive)
    (let* (name rec caller)
      (setq name (completing-read "Who is calling? "
				  (bbdb-hashtable)
				  'bbdb-completion-predicate
				  'confirm))
      (when (> (length name) 0)
	;;Something was supplied -- look it up in bbdb
	(setq rec
	      (or (first
		   (or (bbdb-search (bbdb-records) name nil nil)
		       (bbdb-search (bbdb-records) nil name nil)))
		  name)))

      ;; Build the bbdb link if we have a bbdb record, otherwise just
      ;; return the name.
      (setq caller (cond ((and rec (vectorp rec))
			  (let ((name (bbdb-record-name rec))
				(company (bbdb-record-company rec)))
			    (concat "[[bbdb:"
				    name "]["
				    name "]]"
				    (when company
				      (concat " - " company)))))
			 (rec)
			 (t "NameOfCaller")))
      (insert caller)))


(defun cb/org-todo (arg)
  (interactive "p")
  (if (equal arg 4)
      (save-restriction
	(cb/narrow-to-org-subtree)
	(org-show-todo-tree nil))
    (cb/narrow-to-org-subtree)
    (org-show-todo-tree nil)))

(defun cb/widen ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
	(org-agenda-remove-restriction-lock)
	(when org-agenda-sticky
	  (org-agenda-redo)))
    (widen)))

(defun cb/restrict-to-file-or-follow (arg)
  "Set agenda restrictions to 'file or with argument invoke follow
  mode. I don't use follow mode very often but I restrict to file all
  the time so change the default 'F' binding in the agenda to allow
  both"
  (interactive "p")
  (if (equal arg 4)
      (org-agenda-follow-mode)
    (widen)
    (cb/set-agenda-restriction-lock 4)
    (org-agenda-redo)
    (beginning-of-buffer)))

(defun cb/narrow-to-org-subtree ()
  (widen)
  (org-narrow-to-subtree)
  (save-restriction
    (org-agenda-set-restriction-lock)))

(defun cb/narrow-to-subtree ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
	(org-with-point-at (org-get-at-bol 'org-hd-marker)
	  (cb/narrow-to-org-subtree))
	(when org-agenda-sticky
	  (org-agenda-redo)))
    (cb/narrow-to-org-subtree)))

(defun cb/narrow-up-one-org-level ()
  (widen)
  (save-excursion
    (outline-up-heading 1 'invisible-ok)
    (cb/narrow-to-org-subtree)))

(defun cb/get-pom-from-agenda-restriction-or-point ()
  (or (and (marker-position org-agenda-restrict-begin) org-agenda-restrict-begin)
      (org-get-at-bol 'org-hd-marker)
      (and (equal major-mode 'org-mode) (point))
      org-clock-marker))

(defun cb/narrow-up-one-level ()
  (interactive)
  (if (equal major-mode 'org-mode)
      (progn
	(org-with-point-at (cb/get-pom-from-agenda-restriction-or-point)
	  (cb/narrow-up-one-org-level))
	(org-agenda-redo))
    (cb/narrow-up-one-org-level)))

(defun cb/narrow-to-org-project ()
  (widen)
  (save-excursion
    (cb/find-project-task)
    (cb/narrow-to-org-subtree)))

(defun cb/narrow-to-project ()
  (interactive)
  (if (equal major-mode 'org-agenda-mode)
      (progn
	(org-with-point-at (cb/get-pom-from-agenda-restriction-or-point)
	  (cb/narrow-to-org-project)
	  (save-excursion
	    (cb/find-project-task)
	    (org-agenda-set-restriction-lock)))
	(org-agenda-redo)
	(beginning-of-buffer))
    (cb/narrow-to-org-project)
    (save-restriction
      (org-agenda-set-restriction-lock))))

(defun cb/view-next-project ()
  (interactive)
  (let (num-project-left current-project)
    (unless (marker-position org-agenda-restrict-begin)
      (goto-char (point-min))

      ;; Clear all of the existing markers on the list
      (while cb/project-list
	(set-marker (pop cb/project-list) nil))

      (re-search-forward "Tasks to Refile")
      (forward-visible-line 1))

    ;;Build a new project marker list
    (unless cb/project-list
      (while (< (point) (point-max))
	(while (and (< (point) (point-max))
		    (or (not (org-get-at-bol 'org-hd-marker))
			(org-with-point-at (org-get-at-bol 'org-hd-marker)
			  (or (not (cb/is-project-p))
			      (cb/is-project-subtree-p)))))
	  (forward-visible-line 1))
	(when (< (point) (point-max))
	  (add-to-list 'cb/project-list (copy-marker (org-get-at-bol 'org-hd-marker)) 'append))
	(forward-visible-line 1)))

    ;; Pop off the first marker on the list and display
    (setq current-project (pop cb/project-list))
    (when current-project
      (org-with-point-at current-project
	(setq cb/hide-scheduled-and-waiting-next-tasks nil)
	(cb/narrow-to-project))
      ;;Remove the marker-buffer
      (setq current-project nil)
      (org-agenda-redo)
      (beginning-of-buffer)
      (setq num-projects-left (length cb/project-list))
      (if (> num-projects-left 0)
	  (message "%s projects left to view" num-projects-left)
	(beginning-of-buffer)
	(setq cb/hide-scheduled-and-waiting-next-tasks t)
	(error "All projects viewed.")))))


(defun cb/set-agenda-restriction-lock (arg)
  "Set restriction lock to the current task subtree or file if prefix
is specified"
  (interactive "p")
  (let* ((pom (cb/get-pom-from-agenda-restriction-or-point))
	 (tags (org-with-point-at pom (org-get-tags-at))))
    (let ((restriction-type (if (equal arg 4) 'file' 'subtree)))
      (save-restriction
	(cond
	 ((and (equal major-mode 'org-agenda-mode) pom)
	  (org-with-point-at pom
	   (org-agenda-set-restriction-lock restriction-type))
	  (org-agenda-redo))
	 ((and (equal major-mode 'org-mode)
	       (org-before-first-heading-p))
	  (org-agenda-set-restriction-lock 'file))
	 (pom
	  (org-with-point-at pom
	    (org-agenda-set-restriction-lock restriction-type))))))))

(defun cb/agenda-sort (a b)
  "Sorting strategy for agenda items.
Late deadlines first, then scheduled, then non-late deadlines"
  (let (result num-a num-b)
    (cond
     ;; time specific items are already sorted first by org-agenda-sorting-strategy

     ;;non deadline and non scheduled items next
     ((cb/agenda-sort-test 'cb/is-not-scheduled-or-deadline a b))

     ;; deadlines for today next
     ((cb/agenda-sort-test 'cb/is-due-deadline a b))

     ;; late deadlines next
     ((cb/agenda-sort-test-num 'cb/is-late-deadline '> a b))

     ;; scheduled items for today next
     ((cb/agenda-sort-test 'cb/is-scheduled-today a b))

     ;; late scheduled items next
     ((cb/agenda-sort-test-num 'cb/is-scheduled-late '> a b))

     ;; pending deadlines last 
     ((cb/agenda-sort-test-num 'cb/is-pending-deadline '< a b))

     ;;finally default to unsorted
     (t (setq result nil)))
    result))

(defmacro cb/agenda-sort-test (f a b)
  "Test for agenda sort"
  `(cond
   ;; If both match, leave them unsorted
   ((and (apply ,f (list ,a))
	 (apply ,f (list ,b)))
    (setq result nil))
    ;;if a matches, put it first
   ((apply ,f (list ,a))
    (setq result -1))
   ;;Otherwise put b first
   ((apply ,f (list ,b))
    (setq result 1))
   ;;If none match, leave them unsorted
   (t nil)))

(defmacro cb/agenda-sort-test-num (fn compfn a b)
  `(cond
   ((apply ,fn (list ,a))
    (setq num-a (string-to-number (match-string 1 ,a)))
    (if (apply ,fn (list ,b))
	(progn
	  (setq num-b (string-to-number (match-string 1 ,b)))
	  (setq result (if (apply ,compfn (list num-a num-b))
			   -1
			 1)))
      (setq result -1)))
   ((apply ,fn (list ,b))
    (setq result 1))
   (t nil)))

(defun cb/is-not-scheduled-or-deadline (date-str)
  (and (not (cb/is-deadline date-str))
       (not (cb/is-scheduled date-str))))

(defun cb/is-due-deadline (date-str)
  (string-match "Deadline:" date-str))

(defun cb/is-late-deadline (date-str)
  (string-match "\\([0-9]*\\) d\. ago:" date-str))

(defun cb/is-pending-deadline (date-str)
  (string-match "In \\([^-]*\\)d\.:" date-str))

(defun cb/is-deadline (date-str)
  (or (cb/is-due-deadline date-str)
      (cb/is-late-deadline date-str)
      (cb/is-pending-deadline date-str)))

(defun cb/is-scheduled (date-str)
  (or (cb/is-scheduled-today date-str)
      (cb/is-scheduled-late date-str)))

(defun cb/is-scheduled-today (date-str)
  (string-match "Scheduled:" date-str))

(defun cb/is-scheduled-late (date-str)
  (string-match "Sched\.\\(.*\\)x:" date-str))


;; }}}



;; {{{ Hooks
(add-hook 'org-clock-out-hook 'cb/remove-empty-clock-drawers-on-clock-out 'append)
(add-hook 'org-clock-out-hook 'cb/clock-out-maybe 'append)

;; "W" key widens in agenda view
(add-hook 'org-agenda-mode-hook
	  '(lambda () (org-defkey org-agenda-mode-map "W" (lambda ()
							    (interactive)
							    (setq
							     cb/hide-scheduled-and-waiting-next-tasks
							     t)
							    (cb/widen))))
	  'append)

;; "F" (file) narrows to the current file or file of the existing restriction
(add-hook 'org-agenda-mode-hook
	  '(lambda () (org-defkey org-agenda-mode-map "F"
				  'cb/restrict-to-file-or-follow))
	  'append)

;; N (narrow) narrows to this task subtree
(add-hook 'org-agenda-mode-hook
	  '(lambda () (org-defkey org-agenda-mode-map "N" 'cb/narrow-to-subtree))
	  'append)

;; T (tasks) for C-c / t on the current buffer

;;U (up) narrows to the immediate parent task subtree without moving
(add-hook 'org-agenda-mode-hook
	  '(lambda () (org-defkey org-agenda-mode-map "U" 'cb/narrow-up-one-level))
	  'append)

;;P (project) narrows to the parent project subtree without moving
(add-hook 'org-agenda-mode-hook
	  '(lambda () (org-defkey org-agenda-mode-map "P" 'cb/narrow-to-project))
	  'append)

;;V (view next project)
(add-hook 'org-agenda-mode-hook
	  '(lambda () (org-defkey org-agenda-mode-map "V" 'cb/view-next-project))
	  'append)

;;Add Restriction lock chord to the agenda view
(add-hook 'org-agenda-mode-hook
	  '(lambda () (org-defkey org-agenda-mode-map "\C-c\C-x<" 'cb/set-agenda-restriction-lock))
	  'append)
;; }}}
