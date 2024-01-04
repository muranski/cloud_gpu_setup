;;; .emacs --- Emacs initialization file -*- lexical-binding: t; -*-

;; Standard packages
(require 'cl)
(require 'package)
(require 'uniquify)

;; Enable installation of packages from MELPA
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
;; Ensure packages are installed before they are run. Also frees you
;; from having to put `:ensure t` after installing every package.
(setq use-package-always-ensure t)

;; Enable packages from ~/.emacs.d/lisp/
;; (let ((default-directory "~/.emacs.d/lisp/"))
;;   (normal-top-level-add-to-load-path '("."))
;;   (normal-top-level-add-subdirs-to-load-path))

(use-package standard-themes
  :config
  (load-theme 'standard-dark t))

;; (use-package doom-themes
;;   :config
;;   (load-theme 'doom-acario-dark t))

;; (use-package doom-themes
;;   :config
;;   (load-theme 'doom-dark+ t))

;; (use-package doom-themes
;;   :config
;;   (load-theme 'doom-molokai t))

;; (use-package doom-themes
;;   :config
;;   (load-theme 'doom-monokai-pro t))

;; (use-package github-dark-vscode-theme
;;   :config
;;   (load-theme 'github-dark-vscode t))

;; (use-package vs-dark-theme
;;   :config
;;   (load-theme 'vs-dark t))

;; Enable Selectrum
(use-package selectrum
  :config
  (selectrum-mode +1))
(use-package selectrum-prescient
  :config
  ;; Make sorting and filtering more intelligent
  (selectrum-prescient-mode +1)
  ;; Save command history on disk, so the sorting gets more
  ;; intelligent over time
  (prescient-persist-mode +1))

;; Inhibit startup message
(setq inhibit-splash-screen t)

;; Alias y to yes and n to no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Undo limit size
(setq undo-limit 100000)
(setq undo-strong-limit 200000)

;; Revert buffers periodically
(global-auto-revert-mode t)

;; Show column-number in the mode line
(column-number-mode t)

;; Incremental minibuffer completion preview
(icomplete-mode t)

;; Show unique names for files with the same name
(setq uniquify-buffer-name-style 'post-forward)

;; Highlight the marked text
(transient-mark-mode t)

;; Copy to and paste from the GUI clipboard when running in text terminal
(use-package xclip
  :config
  (xclip-mode 1))

;; Set tab stops 2 spaces apart
(setq tab-stop-list (number-sequence 2 1000 2))

;; When point is on paranthesis, highlight the matching one
(show-paren-mode t)

;; Do not wrap long lines
(setq-default truncate-lines t)

;; Use spaces for tabs
(setq-default indent-tabs-mode nil)

;; Discard trailing whitespace on file save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Always end a file with a newline
(setq require-final-newline t)

;; End sentences with one space, not two (affects fill commands)
(setq-default sentence-end-double-space nil)

;; Turn off auto-saving
(setq auto-save-default nil)

;; Do not create lock files
(setq create-lockfiles nil)

;; Do not create backup files
(setq make-backup-files nil)

;; Turn on syntax highlighting
(global-font-lock-mode t)

;; Highlight lines longer than 80 characters
(use-package column-enforce-mode
  :delight
  :config (global-column-enforce-mode t))

;; Indent by 2 spaces
(setq c-basic-offset 2)
(setq css-indent-offset 2)
(setq sh-basic-offset 2)
(setq-default python-indent-offset 2)

;; Disable menu bar
(unless window-system
  (menu-bar-mode -1))

;; Enable mouse support
(unless window-system
  (xterm-mouse-mode 1)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

;; Hide scrollbars and toolbar in windows mode
(when window-system
  (scroll-bar-mode -1)
  (tool-bar-mode -1))

;; Set font in windows mode
(when window-system
  (set-face-attribute 'default nil :family "SF Mono" :height 140))

;; Custom functions

(defun revert-all-buffers ()
  (interactive)
  (let ((current-buffer (buffer-name)))
    (loop for buf in (buffer-list)
          do
          (unless (null (buffer-file-name buf))
            (switch-to-buffer (buffer-name buf))
            (revert-buffer nil t)))
    (switch-to-buffer current-buffer)
    (message "All buffers reverted!")))
(define-key global-map [?\M-r] 'revert-all-buffers)

(defun whack-whitespace ()
  (interactive)
  (let ((regexp "[ \t\n]+"))
    (re-search-forward regexp nil t)
    (replace-match "" nil nil)))
(define-key global-map [?\M-s] 'whack-whitespace)

;; Automatically added

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(column-enforce-mode xclip selectrum-prescient selectrum standard-themes use-package)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
