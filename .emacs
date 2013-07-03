;;;; General settings
(require 'cl)
(setq safe-local-variable-values '((org-adapt-indentation)))
(prefer-coding-system 'utf-8-unix)
(setq-default indent-tabs-mode nil)
(setq dired-listing-switches "-alh")
(setq inhibit-startup-screen t)
(setq initial-scratch-message "")
(setq-default show-trailing-whitespace t)
(setq revert-without-query '(".*"))
(menu-bar-mode -1)
(set-scroll-bar-mode nil)
(blink-cursor-mode 0)
(show-paren-mode 1)
(put 'narrow-to-region 'disabled nil)

;;;; Global key bindings
(global-set-key (kbd "C-x C-b") 'bs-show)

(global-set-key (kbd "C-c SPC") 'ace-jump-mode)
(global-set-key (kbd "C-c b") 'ace-jump-mode-pop-mark)

(global-set-key (kbd "C-c C-g") 'magit-status)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

(global-set-key (kbd "<f5>") 'revert-buffer-no-confirm)

(global-set-key (kbd "<f12>") 'other-window)

;;;; My Prefix
(define-prefix-command 'lex-map)
(define-key lex-map (kbd "s") 'shell)
(define-key lex-map (kbd "v") 'visual-line-mode)
(define-key lex-map (kbd "r") 'windresize)
(define-key lex-map (kbd "g") 'rgrep)
(define-key lex-map (kbd "c") 'calc)
(define-key lex-map (kbd "t") 'toggle-truncate-lines)
(global-set-key (kbd "C-c s") 'lex-map)

;;;; Mode specific bindings
(eval-after-load 'comint
  '(progn (define-key comint-mode-map (kbd "C-c SPC") nil)))

(eval-after-load 'org
  '(progn (define-key org-mode-map (kbd "C-c SPC") nil)
          (add-to-list 'org-modules 'org-habit)))

(eval-after-load 'magit 
  '(progn (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)))

(setq smerge-command-prefix (kbd "C-c"))

;;;; Packages
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(guide-key
                      windresize
                      browse-kill-ring
                      unbound
                      ace-jump-mode
                      org
                      magit
                      scala-mode2
                      erlang)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;;; Browse Kill Ring
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;;;; Magit
(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

;;;; Ace-jump mode
(setq ace-jump-sync-emacs-mark-ring t)

;;;; Guide key
(guide-key-mode 1)
(setq guide-key/guide-key-sequence '("C-c s"))

;;;; Ido-mode
(ido-mode t)
(setq ido-use-virtual-buffers t)
(setq ido-enable-flex-matching t)

;;;; Calc
(setq math-additional-units '(
  (YiB "1024 * ZiB" "yobibyte")
  (ZiB "1024 * EiB" "zebibyte")
  (EiB "1024 * PiB" "exbibyte")
  (PiB "1024 * TiB" "pebibyte")
  (TiB "1024 * GiB" "tebibyte")
  (GiB "1024 * MiB" "gibibyte")
  (MiB "1024 * KiB" "mebibyte")
  (KiB "1024 * B" "kibibyte")
  (B "byte" "one byte")
  (byte "8 * bit" "eight bits")
  (bit nil "basic unit of information")
))

;;;; Org-mode
(setq org-agenda-files (list "~/org"))
(setq org-mobile-directory "/var/dav")

(setq calendar-week-start-day 1)
(setq org-agenda-dim-blocked-tasks nil)
(setq org-agenda-ndays 7)
(setq org-agenda-repeating-timestamp-show-all nil)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-tags-todo-honor-ignore-options t)
(setq org-clock-modeline-total 'today)
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-mobile-force-id-on-agenda-items nil)
(setq org-refile-use-outline-path t)
(setq org-reverse-note-order t)
(setq org-habit-show-habits-only-for-today nil)

(add-hook 'org-agenda-mode-hook '(lambda () (setq show-trailing-whitespace nil)))

(setq org-todo-keyword-faces
      '(
        ("STAR"  . (:foreground "DarkOrchid1" :weight bold))
        ("WAIT"  . (:foreground "orange1" :weight bold))
        ("DEFE"  . (:foreground "yellow green" :weight bold))
        ("CNLD"  . (:foreground "grey50" :weight bold))
        ))

(setq org-refile-targets (quote (("gtd.org" :maxlevel . 2) (nil :maxlevel . 5))))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Inbox")
             "* TODO %^{Brief Description}\n  %U\n  %?")))

(setq org-agenda-custom-commands
      '(
        ("o" "Office block agenda"
         ((agenda "" ((org-agenda-ndays 1)))
          (tags-todo "WORK" ))
         ((org-agenda-compact-blocks t)
	  (org-agenda-sorting-strategy '(todo-state-down))))
        ("p" "Private block agenda"
         ((agenda "" ((org-agenda-ndays 1)))
          (tags-todo "-WORK"
                     ((org-agenda-todo-ignore-scheduled 'all)
                      (org-agenda-todo-ignore-deadlines 'all)))))))

(defun move-captured-notes ()
  "Move Captures from mobile-org to Inbox"
  (interactive)
  (find-file "~/org/from-mobile.org")
  (beginning-of-buffer)
  (while (org-on-heading-p)
    (execute-kbd-macro "\C-c\C-wInbox  \C-m")
    )
  (save-buffer)
  (find-file "~/org/gtd.org")
  (save-buffer))


;;;; Functions
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive) (revert-buffer t t))

;;;; Theme
(deftheme Nirun
  "Created 2013-06-12.")

(custom-theme-set-faces
 'Nirun
 '(diff-added ((t (:foreground "chartreuse2"))))
 '(diff-changed ((t ())))
 '(diff-indicator-added ((t (:inherit diff-indicator-changed))))
 '(diff-indicator-changed ((t (:weight bold))))
 '(diff-indicator-removed ((t (:inherit diff-indicator-changed))))
 '(diff-removed ((t (:foreground "DeepPink1"))))
 '(smerge-refined-added ((t (:inherit diff-added))))
 '(smerge-refined-removed ((t (:inherit diff-removed))))
 '(smerge-mine ((t (:inherit magit-item-highlight))))
 '(smerge-other ((t (:inherit magit-item-highlight))))
 '(dired-directory ((t (:foreground "DodgerBlue" :weight bold))))
 '(error ((t (:foreground "deep pink" :weight bold))))
 '(font-lock-builtin-face ((t (:foreground "medium purple"))))
 '(font-lock-comment-face ((t (:foreground "chartreuse2"))))
 '(font-lock-constant-face ((t (:foreground "dodger blue"))))
 '(font-lock-doc-face ((t (:foreground "indian red"))))
 '(font-lock-function-name-face ((t (:foreground "DeepSkyBlue1"))))
 '(font-lock-keyword-face ((t (:foreground "DeepSkyBlue3" :weight bold))))
 '(font-lock-preprocessor-face ((t (:foreground "yellow green"))))
 '(font-lock-string-face ((t (:foreground "gold1"))))
 '(font-lock-type-face ((t (:foreground "orange1"))))
 '(font-lock-variable-name-face ((t (:foreground "DarkOrchid1"))))
 '(font-lock-warning-face ((t (:foreground "DeepPink1"))))
 '(gnus-button ((t (:inherit button))))
 '(gnus-cite-1 ((t (:foreground "dark turquoise"))))
 '(gnus-group-mail-1 ((t (:inherit gnus-group-mail-1-empty :weight bold))))
 '(gnus-group-mail-1-empty ((t (:foreground "#00CC00"))))
 '(gnus-group-mail-3 ((t (:inherit gnus-group-mail-3-empty :weight bold))))
 '(gnus-group-mail-3-empty ((t (:foreground "#009999"))))
 '(gnus-group-news-3 ((t (:inherit gnus-group-news-3-empty :weight bold))))
 '(gnus-group-news-3-empty ((t (:foreground "light green"))))
 '(gnus-header-content ((t (:foreground "#A64B00"))))
 '(gnus-header-name ((t (:weight bold))))
 '(gnus-header-subject ((t (:foreground "#A64B00" :weight bold))))
 '(gnus-summary-high-ancient ((t (:foreground "#A64B00" :weight bold))))
 '(gnus-summary-low-ancient ((t (:foreground "medium turquoise" :slant italic))))
 '(gnus-summary-low-read ((t (:foreground "dark sea green" :slant italic))))
 '(header-line ((t (:inverse-video t :box (:line-width -1 :color "red" :style released-button)))))
 '(helm-header ((t (:background "DeepSkyBlue4" :weight bold))))
 '(highlight ((t (:background "sea green"))))
 '(hl-line ((t (:background "grey25"))))
 '(hl-paren-face ((t (:weight bold))))
 '(icomplete-first-match ((t (:foreground "deep sky blue" :weight bold))))
 '(ido-first-match ((t (:foreground "turquoise" :weight bold))))
 '(ido-only-match ((t (:foreground "medium spring green" :weight bold))))
 '(ido-subdir ((t (:inherit dired-directory :weight normal))))
 '(lusty-file-face ((t (:foreground "SpringGreen1"))))
 '(magit-header ((t (:box 1 :weight bold))))
 '(magit-section-title ((t (:inherit magit-header :background "dark slate blue"))))
 '(magit-item-highlight ((t (:background "gray21"))))
 '(menu ((t (:background "gray30" :foreground "gray70"))))
 '(minibuffer-prompt ((t (:foreground "DeepPink2" :weight bold))))
 '(mode-line ((t (:foreground "brightwhite" :background "purple3"))))
 '(mode-line-inactive ((t (:background "gray22" :foreground "dim gray"))))
 '(org-agenda-date ((t (:inherit org-agenda-structure))))
 '(org-agenda-date-today ((t (:inherit org-agenda-date :underline t))))
 '(org-agenda-date-weekend ((t (:inherit org-agenda-date :foreground "LightSteelBlue"))))
 '(org-agenda-done ((t (:foreground "#269926"))))
 '(org-agenda-restriction-lock ((t (:background "#FFB273"))))
 '(org-agenda-structure ((t (:foreground "Dodger blue" :weight bold))))
 '(org-date ((t (:foreground "medium sea green" :underline t))))
 '(org-done ((t (:foreground "chartreuse2" :weight bold))))
 '(org-drawer ((t (:foreground "#2A4480"))))
 '(org-ellipsis ((t (:foreground "#FF7400" :underline t))))
 '(org-footnote ((t (:foreground "#1240AB" :underline t))))
 '(org-habit-alert-face ((t (:background "gold1" :foreground "black"))))
 '(org-habit-alert-future-face ((t (:background "gold3" :foreground "black"))))
 '(org-habit-clear-face ((t (:background "DeepSkyBlue1" :foreground "black"))))
 '(org-habit-clear-future-face ((t (:background "DeepSkyBlue3" :foreground "black"))))
 '(org-habit-overdue-face ((t (:background "DeepPink1" :foreground "black"))))
 '(org-habit-overdue-future-face ((t (:background "DeepPink3" :foreground "black"))))
 '(org-habit-ready-face ((t (:background "chartreuse2" :foreground "black"))))
 '(org-habit-ready-future-face ((t (:background "chartreuse3" :foreground "black"))))
 '(org-hide ((t (:foreground "gray20"))))
 '(org-level-1 ((t (:inherit outline-1 :box nil))))
 '(org-level-2 ((t (:inherit outline-2 :box nil))))
 '(org-level-3 ((t (:inherit outline-3 :box nil))))
 '(org-level-4 ((t (:inherit outline-4 :box nil))))
 '(org-level-5 ((t (:inherit outline-5 :box nil))))
 '(org-level-6 ((t (:inherit outline-6 :box nil))))
 '(org-level-7 ((t (:inherit outline-7 :box nil))))
 '(org-level-8 ((t (:inherit outline-8 :box nil))))
 '(org-scheduled ((t (:foreground "chartreuse2"))))
 '(org-scheduled-previously ((t (:foreground "#FF7400"))))
 '(org-tag ((t (:weight bold))))
 '(org-todo ((t (:foreground "DeepPink1" :weight bold))))
 '(outline-1 ((t (:foreground "cyan1" :weight bold))))
 '(outline-2 ((t (:foreground "SeaGreen1" :weight bold))))
 '(outline-3 ((t (:foreground "cyan3" :weight bold))))
 '(outline-4 ((t (:foreground "SeaGreen3" :weight bold))))
 '(outline-5 ((t (:foreground "LightGoldenrod1" :weight bold))))
 '(outline-6 ((t (:foreground "light salmon" :weight bold))))
 '(outline-7 ((t (:foreground "pale goldenrod" :weight bold))))
 '(outline-8 ((t (:foreground "OliveDrab1" :weight bold))))
 '(rcirc-my-nick ((t (:foreground "SpringGreen1" :weight bold))))
 '(rcirc-other-nick ((t (:foreground "dodger blue"))))
 '(rcirc-track-keyword ((t (:foreground "DodgerBlue" :weight bold))))
 '(rcirc-track-nick ((t (:background "yellow" :foreground "DodgerBlue" :weight bold))))
 '(region ((t (:background "SeaGreen4"))))
 '(scroll-bar ((t (:background "gray20" :foreground "dark turquoise"))))
 '(secondary-selection ((t (:background "#333366" :foreground "#f6f3e8"))))
 '(show-paren-match ((t (:background "DeepSkyBlue4"))))
 '(show-paren-mismatch ((t (:background "dark magenta"))))
 '(th-sentence-hl-face ((t (:weight bold))))
 '(widget-field ((t (:box (:line-width 2 :color "grey75" :style pressed-button)))))
 '(window-number-face ((t (:foreground "red" :weight bold))))
 '(trailing-whitespace ((t (:background "gray22"))))
 '(fringe ((t (:inherit default))))
 '(default ((t (:background "gray20" :foreground "white smoke")))))
