(require 'package)
(setq package-enable-at-startup nil
      package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa" . "https://melpa.org/packages/")
                         ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))
;; (setq gnutls-algorithm-priority "normal:-vers-tls1.3")

(setq custom-file "~/.config/emacs-vanilla/custom.el")
(load custom-file)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(setq make-backup-files nil)

(cond
 ((find-font (font-spec :name "SF Mono"))
  (set-frame-font "SF Mono-14"))
 ((find-font (font-spec :name "Menlo"))
  (set-frame-font "Menlo-14"))
 ((find-font (font-spec :name "DejaVu Sans Mono"))
  (set-frame-font "DejaVu Sans Mono-14"))
 ((find-font (font-spec :name "Inconsolata"))
  (set-frame-font "Inconsolata-14")))

(package-initialize)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

;;; Vim Bindings
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  ;; allows for using cgn
  ;; (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  ;; no vim insert bindings
  :config
  (evil-mode 1))

(setq evil-undo-system 'undo-redo)

(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

(use-package doom-themes
  :config
  (load-theme 'doom-dracula t))

(pixel-scroll-precision-mode)
(display-time-mode 1)
(global-subword-mode 1)

(setq undo-limit 80000000
      evil-want-fine-undo t
      auto-save-default t
      truncate-string-ellipsis "…"
      password-cache-expiry nil
      display-time-default-load-average nil)

(use-package evil-owl
  :config
  (setq evil-owl-max-string-length 500)
  (setq evil-owl-idle-delay 0.5)
  (add-to-list 'display-buffer-alist
               '("*evil-owl*"
                 (display-buffer-in-side-window)
                 (side . bottom)
                 (window-height . 0.3)))
  (evil-owl-mode))

(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 2))

(setq inhibit-startup-screen t)
(blink-cursor-mode -1)
(setq ring-bell-function 'ignore)
;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)

(setq mac-option-modifier 'nil
      mac-command-modifier 'meta
      mac-function-modifier 'super
      select-enable-clipboard t)

(use-package saveplace
  :config
  ;; activate it for all buffers
  (setq-default save-place t))

(use-package hl-line
  :config
  (global-hl-line-mode +1))

(use-package paren
  :config
  (show-paren-mode +1))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

(use-package calendar
  :config
  (setq calendar-week-start-day 1))

(use-package savehist
  :config
  (setq savehist-additional-variables
        ;; search entries
        '(search-ring regexp-search-ring)
        ;; save every minute
        savehist-autosave-interval 60)
  (savehist-mode +1))

(use-package magit
  :ensure t)

;; Keybindings

(evil-set-leader 'normal (kbd "SPC"))

(defvar my-leader-map (make-sparse-keymap)
  "Keymap for \"leader key\" shortcuts.")

(defvar my-magit-map (make-sparse-keymap)
  "Keymap for \"leader key\" shortcuts.")

(define-key evil-normal-state-map (kbd "SPC") my-leader-map)
(define-key my-leader-map "b" 'list-buffers)
(define-key my-leader-map "g g" 'magit-status)

(define-key evil-normal-state-map (kbd "SPC g") my-magit-map)
(define-key my-magit-map "g" 'magit-status)
