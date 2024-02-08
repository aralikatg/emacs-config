(setq max-lisp-eval-depth 10000)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; load packages
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package helm
  :ensure t
  :demand
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x c o" . helm-occur)) ;SC
         ("M-y" . helm-show-kill-ring) ;SC
  :preface (require 'helm-config)
  :config (helm-mode 1))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package doom-themes)

;; do this in :config
(load-theme 'doom-gruvbox t)

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-terminal-cursor-changer
  :after evil
  :config (evil-terminal-cursor-changer-activate))

(global-unset-key (kbd "C-SPC"))
(global-unset-key (kbd "C-x b"))
(xterm-mouse-mode 1)

(use-package multi-vterm
        :config
        (add-hook 'vterm-mode-hook
                        (lambda ()
                        (setq-local evil-insert-state-cursor 'box)
                        (evil-insert-state))))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

(use-package general
  :after evil
  :config
  (general-create-definer aralikat/leader-keys
    :keymaps '(normal insert visual)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (aralikat/leader-keys
    "f" '(fig-status :which-key "fig status")
    "q" '(keyboard-escape-quit :which-key "escape popup")
    "b" '(:which-key "buffer")
    "br" '(revert-buffer :which-key "revert buffer")
    "bb" '(helm-buffers-list :which-key "buffer list")
    "be" '(eval-buffer :which-key "evaluate buffer")
    "c"  '(:which-key "google3 blaze")
    "cc" '(google3-build-cleaner :which-key "build cleaner")
    "cb" '(google3-build :which-key "build")
    "ct" '(google3-test :which-key "test")
    "cf" '(google-diformat-clang-format-changed :which-key "format")
    "cm" '(google-codemaker :which-key "codemaker")
    "rb" '(helm-filtered-bookmarks :which-key "bookmarks")
    "rm" '(bookmark-set :which-key "bookmarks")
    "k" '(:which-key "code")
    "ko" '(comment-region :which-key "comment out")
    "ki" '(uncomment-region :which-key "comment in")
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(load-theme :which-key "choose theme" t)))

(use-package undo-tree
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

(global-auto-revert-mode 1)
(setq custom-file (concat user-emacs-directory "/custom.el"))
(setq helm-buffer-max-length 40)

;; google specifc
(require 'google)
(require 'fig)
(require 'google3-build)
(require 'google3-eglot)
(customize-set-variable google3-eglot-c++-server 'clangd)
(google3-eglot-setup)
(add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
(global-company-mode t)
(require 'google-yasnippets)
(google-yasnippets-load)
