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

(defvar bootstrap-version)

(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

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

(use-package vertico
  :ensure t
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy)
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)
  )

(use-package vertico-multiform
  :ensure nil
  :hook (after-init . vertico-multiform-mode))

(use-package dabbrev
  :custom
  (dabbrev-upcase-means-case-search t)
  (dabbrev-check-all-buffers nil)
  (dabbrev-check-other-buffers t)
  (dabbrev-friend-buffer-function 'dabbrev--same-major-mode-p)
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))

(use-package corfu
  :ensure t
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-on-exact-match 'insert) ;; Insert when there's only one match
  (corfu-quit-no-match t)        ;; Quit when ther is no match
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary

  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.
  ;; This is recommended since Dabbrev can be used globally (M-/).
  ;; See also `corfu-excluded-modes'.
  :init
  (setq corfu-exclude-modes '(eshell-mode))
  (global-corfu-mode))

(use-package cape
  :ensure t
  :init
  (setq cape-dabbrev-min-length 2)
  (setq cape-dabbrev-check-other-buffers 'some)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;; (add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input)
                (eq (current-local-map) read-passwd-map))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))

  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)
  :bind ("C-c SPC" . cape-dabbrev)
  )

(use-package orderless
  :ensure t
  :after consult
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult
  :ensure
  :after projectile
  :bind (("C-s" . consult-line)
         ("C-c M-x" . consult-mode-command)
         ("C-x b" . consult-buffer)
         ("C-x r b" . consult-bookmark)
         ("M-y" . consult-yank-pop)
         ;; M-g bindings (goto-map)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("C-z" . consult-theme)
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history)
         :map projectile-command-map
         ("b" . consult-project-buffer)
         :map prog-mode-map
         ("M-g o" . consult-imenu))

  :init
  (defun remove-items (x y)
    (setq y (cl-remove-if (lambda (item) (memq item x)) y))
    y)

  ;; Any themes that are incomplete/lacking don't work with centaur tabs/solair mode
  (setq consult-project-function (lambda (_) (projectile-project-root)))
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  (setq consult-narrow-key "<")
  (setq consult-line-start-from-top nil))

(use-package consult-ag
  :ensure
  :defer
  :bind (:map projectile-command-map
              ("s s" . consult-ag)
              ("s g" . consult-grep)))

(use-package consult-org-roam
  :ensure t
  :after org-roam
  :init
  (require 'consult-org-roam)
  ;; Activate the minor mode
  (consult-org-roam-mode 1)
  :custom
  (consult-org-roam-grep-func #'consult-ag)
  ;; Configure a custom narrow key for `consult-buffer'
  (consult-org-roam-buffer-narrow-key ?r)
  ;; Display org-roam buffers right after non-org-roam buffers
  ;; in consult-buffer (and not down at the bottom)
  (consult-org-roam-buffer-after-buffers nil)
  :config
  ;; Eventually suppress previewing for certain functions
  (consult-customize
   consult-org-roam-forward-links
   :preview-key (kbd "M-.")))

(use-package marginalia
  :ensure
  :init
  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config (column-number-mode 1)
  :custom
  (doom-modeline-height 30)
  (doom-modeline-window-width-limit nil)
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-minor-modes nil)
  (doom-modeline-enable-word-count nil)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-env-python-executable "python")
  ;; needs display-time-mode to be one
  (doom-modeline-time t)
  (doom-modeline-vcs-max-length 50))

(use-package embark
  :ensure t
  :defer
  :bind (("C-." . embark-act)))

(use-package embark-consult
  :ensure t
  :after embark)

(use-package rainbow-mode
  :defer
  :ensure t
  :hook (prog-mode . rainbow-mode))

(use-package visual-fill-column
  :ensure t
  :defer
  :custom
  (visual-fill-column-width 140)
  (visual-fill-column-center-text t))

(use-package tree-sitter
  :hook (prog-mode . turn-on-tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config (require 'tree-sitter-langs)
  ;; This makes every node a link to a section of code
  (setq tree-sitter-debug-jump-buttons t
        ;; and this highlights the entire sub tree in your code
        tree-sitter-debug-highlight-jump-region t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :config (setq rainbow-delimiters-max-face-count 4))

;; Show info about the file under editing, see: 'https://github.com/Artawower/file-info.el'
(use-package file-info
  :ensure t
  :bind (("C-c d" . 'file-info-show)))

(use-package yank-indent
  :straight (:host github :repo "jimeh/yank-indent")
  :config (global-yank-indent-mode t))

;; Projectile

(use-package projectile
  :ensure t)

(setq projectile-enable-caching nil)
(setq projectile-project-search-path '("~/dev"))

(evil-define-key 'normal 'global (kbd "ö") 'save-buffer)
(evil-define-key 'normal 'global (kbd "ä") 'delete-other-windows)
(evil-define-key 'normal 'global (kbd "C-ä") 'split-window-right)
(evil-define-key 'normal 'global (kbd "C-ö") 'split-window-below)
(evil-define-key 'normal 'global (kbd "C-å") 'consult-line)
(evil-define-key 'normal 'global (kbd "Ö") 'xref-find-definitions)
(evil-define-key 'normal 'global (kbd "å") 'yank-from-kill-ring)
(evil-define-key 'normal 'global (kbd "¨") 'evil-ex-search-forward)
(evil-define-key 'normal 'global (kbd "C-j") 'evil-window-next)
(evil-define-key 'normal 'global (kbd "C-k") 'evil-window-prev)

(setq kill-ring-max 1000)

(setq which-key-idle-delay 0.5)

(setq global-visual-line-mode t)
(global-auto-revert-mode t)

(pixel-scroll-precision-mode)
(display-time-mode 1)
(global-subword-mode 1)

(setq undo-limit 80000000
      evil-want-fine-undo t
      auto-save-default t
      truncate-string-ellipsis "…"
      password-cache-expiry nil
      display-time-default-load-average nil)

;; Line numbers

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
