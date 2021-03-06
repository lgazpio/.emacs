;; User Details
(setq user-full-name "Inigo Lopez-Gazpio")
(setq user-mail-address "inigo.lopez@ehu.eus")

;; Environment
(setenv "PATH" (concat "/usr/local/bin:/opt/local/bin:/usr/bin:/bin" (getenv "PATH")))
;; (add-to-list 'exec-path (concat (getenv "GOPATH") "/bin"))
(require 'cl)

;; Package Management
;; Since Emacs 24, Emacs includes the Emacs Lisp Package Archive (ELPA) by default
(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit)))

(defvar packages '(ac-slime
		   auto-complete
		   autopair
		   clojure-mode
		   coffee-mode
		   csharp-mode
		   deft
		   erlang
		   feature-mode
		   flycheck
		   gist
		   go-autocomplete
		   go-eldoc
		   go-mode
		   graphviz-dot-mode
		   haml-mode
		   haskell-mode
		   htmlize
		   idris-mode
		   magit
		   markdown-mode
		   marmalade
		   nodejs-repl
		   o-blog
		   org
		   paredit
		   php-mode
		   puppet-mode
		   restclient
		   rvm
		   scala-mode
		   smex
		   sml-mode
		   solarized-theme
		   web-mode
		   writegood-mode
		   yaml-mode)
  "Default packages")

(defun packages-installed-p ()
  (loop for pkg in packages
	when (not (package-installed-p pkg)) do (return nil)
	finally (return t)
	)
  )

(unless (packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))
    )
  )

;; Remove initial screen
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'text-mode)

;; Remove some Menu bar modes
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Marking text
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; Display settings
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; Identation
(setq tab-width 2
      indent-tabs-mode nil)

;; Backup
(setq make-backup-files nil)

;; Yes and no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Key bindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-c m") 'magit-status)

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t
)
(show-paren-mode t)
(toggle-truncate-lines t)
(setq column-number-mode t)
(global-auto-revert-mode 1)

(require 'org)

(require 'autopair)
(autopair-global-mode 1)

(require 'auto-complete-config)
(ac-config-default)

;; Identation and buffer clean-up
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

(setq-default show-trailing-whitespace t)

;; flyspell
(setq flyspell-issue-welcome-flag nil)
(if (eq system-type 'darwin)
    (setq-default ispell-program-name "/usr/local/bin/aspell")
  (setq-default ispell-program-name "/usr/bin/aspell"))
(setq-default ispell-list-command "list")
(flyspell-mode 1)
