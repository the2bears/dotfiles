;;Bootstrap use-package
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

  ;;Add straight 
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

  ;; tells straight where to find the vertico extensions, orignally was (straight-use-package 'use-package)
(straight-use-package '(vertico :files (:defaults "extensions/*")
                        :includes (vertico-buffer
                                   vertico-directory
                                   vertico-flat
                                   vertico-indexed
                                   vertico-mousen
                                   vertico-quick
                                   vertico-repeat
                                   vertico-reverse)))
(setq straight-use-package-by-default t)

;;Personal Info
(setq user-full-name "William Swaney"
      user-mail-address "the2bears@gmail.com")

  ;;This helps speed up loading
(eval-and-compile
  (setq gc-cons-threshold 402653184
        gc-cons-percentage 0.6))

  ;;Sets the custom file so emacs won't write to init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

  ;;globals
(global-auto-revert-mode)
(global-hl-line-mode +1)
(scroll-bar-mode -1)

  ;;Basic settings and properties
(setq auto-revert-verbose nil
      explicit-shell-file-name "/bin/zsh"
      inhibit-startup-message t
      visible-bell nil)
(save-place-mode 1)
(tool-bar-mode -1) 

  ;;For Mac(?)
(toggle-frame-fullscreen)
(use-package exec-path-from-shell
  :straight t
  :init
  (exec-path-from-shell-initialize))

(defalias 'yes-or-no-p 'y-or-n-p)

;; ========
  ;; diminish
  ;; ========
  ;;This package implements hiding or abbreviation of the mode line displays (lighters) of minor-modes.
(use-package diminish
    :straight t)

  ;; =========
  ;; undo-tree
  ;; =========
(use-package undo-tree
  :straight t
  :diminish undo-tree-mode
  :init
  (global-undo-tree-mode)
  :custom
  (undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

  ;; ==========
  ;; marginalia
  ;; ==========
  ;; Enable richer annotations in minibuffers using the Marginalia package
(use-package marginalia
  :straight t
  :ensure t
  :after vertico
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  ;; The :init configuration is always executed (Not lazy!)
  :init
  (marginalia-mode))

  ;; =========
  ;; which-key
  ;; =========
  ;; A minor mode for Emacs that displays the key bindings following your currently entered incomplete command
(use-package which-key
  :straight t
  :diminish which-key-mode
  :init
  (which-key-mode +1))

  ;; =============
  ;; expand-region
  ;; =============
  ;; Expand region increases the selected region by semantic units. 
(use-package expand-region
  :straight t
  :ensure t
  :bind ("C-=" . er/expand-region))


  ;; =======
  ;; company
  ;; =======
  ;; Stands for 'complete anything' and is a completion framework.
(use-package company
  :straight t
  :diminish company-mode
  :init
  (global-company-mode 1)
  (setq company-idle-delay 0.5)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-align-annotations t)
  (setq company-backends '((company-capf company-dabbrev-code))))

  ;; =========
  ;; prescient  
  ;; =========
  ;; A library which sorts and filters lists of candidates - w/company
(use-package company-prescient
  :straight t
  :after company
  :config
  (company-prescient-mode 1)
  (prescient-persist-mode 1))

  ;; =======
  ;; vertico
  ;; =======
  ;; For mini-buffer completion
(use-package vertico
  :straight t
  :init
  (vertico-mode))
    ;; Configure directory extension.
(use-package vertico-directory
  :straight t
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

    ;; =========
    ;; orderless
    ;; =========
    ;; added completion styles
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

  ;; ========
  ;; savehist
  ;; ========
  ;;built in savehist remembers previous selections in mini-buffer selections
(use-package savehist
  :init
  (savehist-mode))

  ;; ======
  ;; embark
  ;; ======
  ;; context actions... normally we have function->obj but this also adds
  ;; obj->function work flow
(use-package embark
  :straight t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

  ;; =======
  ;; consult
  ;; =======
  ;; Example configuration for Consult
(use-package consult
  :straight f
  :ensure t
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (("C-x b" . consult-buffer)
         ("C-x C-b" . consult-buffer)
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("M-s g" . consult-grep)))

  ;; ==========
  ;; super-save
  ;; ==========
  ;; saves buffers when they lose focus
(use-package super-save
  :straight t
  :diminish super-save-mode
  :config
  (super-save-mode +1))

  ;; ====
  ;; helm
  ;; ====
  ;; framework for incremental completions and narrowing selections.
;; (use-package helm
;;   :straight t)

  ;; ================
  ;; multiple-cursors
  ;; ================
  ;; Multiple cursors for Emacs
(use-package multiple-cursors
  :straight t)

  ;; ======
  ;; swiper
  ;; ======
  ;; for searching - TODO add swiper-helm?
(use-package swiper
  :straight t
  :config (global-set-key (kbd "C-s") 'swiper))

  ;; ============
  ;; golden-ratio
  ;; ============
  ;; Adjusts size of active window
(use-package golden-ratio
  :straight t
  :ensure t
  :config (golden-ratio-mode 1))

;;Load the theme
(load-theme 'modus-vivendi t)
(setq modus-themes-org-blocks 'gray-background)

;;Default is Mocha
(use-package catppuccin-theme
  :straight t
  :ensure t)
;;(straight-use-package 'catppuccin-theme)
;;(load-theme 'catppuccin :no-confirm)
;;(setq catppuccin-flavor 'macchiato) ;; or 'latte, 'macchiato, or 'mocha
;;(catppuccin-reload)

(use-package rainbow-delimiters
  :straight t
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(defun t2b/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq org-directory "~/.org"))

;;(setq org-directory "~/.org")
(use-package org
  :hook (org-mode . t2b/org-mode-setup)
  :ensure t
  :defer t
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-fontify-quote-and-verse-blocks t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 2
        org-hide-block-startup t
        org-src-preserve-indentation nil
        org-startup-folded 'content
        org-cycle-separator-lines 2))

(use-package org-bullets
  :straight t
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;;https://emacs.stackexchange.com/questions/71714/how-do-i-define-default-language-for-org-mode-source-code-blocks
(require 'org-tempo)

(set-face-attribute 'org-document-title nil :font "Iosevka Aile" :weight 'bold :height 1.3)
(dolist (face '((org-level-1 . 1.6)
                (org-level-2 . 1.4)
                (org-level-3 . 1.2)
                (org-level-4 . 1.1)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)
                (org-link . 1.1)                  
                (org-block-begin-line . 1.1)))
  (set-face-attribute (car face) nil :font "Iosevka Aile" :weight 'medium :height (cdr face)))

      ;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :height 1.2 :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

      ;; Get rid of the background on column views
(set-face-attribute 'org-column nil :background nil)
(set-face-attribute 'org-column-title nil :background nil)


(when (not (file-exists-p "~/.org"))
  (make-directory "~/.org" t))

(setq org-agenda-files (append (directory-files-recursively "~/org-mode_workspace/" "\\.org$")
                               (directory-files-recursively "~/.org/" "\\.org$")))

(defun t2b/org-mode-agenda-files-update ()
  (message "t2b/org-mode-agenda-files-update")
  (setq org-agenda-files (append (directory-files-recursively "~/org-mode_workspace/" "\\.org$")
                               (directory-files-recursively "~/.org/" "\\.org$"))))

(add-hook 'org-capture-after-finalize-hook 't2b/org-mode-agenda-files-update)

(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-capture-templates `(("t" "Todo [monthly]" entry
                               (file+headline ,(format-time-string "~/.org/tasks/tasks-%Y-%b.org") ,(format-time-string "%Y-%b-%d"))
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/.org/tickler.org" "Tickler")
                               "* %i%? \n %U")))

;;Auto-tangle
(use-package org-auto-tangle
  :straight t
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(use-package org-roam
  :straight t
  :ensure t
  :init (setq org-roam-v2-ack t)
  :custom
    (org-roam-directory "~/org-mode_workspace/org-roam")
    (org-roam-completion-everywhere t)
  :bind
    (("C-c r l" . org-roam-buffer-toggle)
     ("C-c r f" . org-roam-node-find)
     ("C-c r i" . org-roam-node-insert)
     ("C-c r c" . org-roam-capture)
   ;;Dailies
     ("C-c r j" . org-roam-dailies-capture-today)
     :map org-mode-map ("C-M-i" . completion-at-point))
  :config
    (org-roam-db-autosync-mode)
    (org-roam-setup))

;; =====
;; magit
;; =====
;; best. git. client. ever.
(use-package magit
  :straight t
  :ensure t
  :bind (("C-x g" . magit-status)))

;; ===========
;; magit-delta
;; ===========
;; using 'delta' for git diffs
(use-package magit-delta
  :straight t
  :ensure t
  :after magit
  :hook (magit-mode . magit-delta-mode))

;; ===============
;; git-timemachine
;; ===============
;; move back and forth between revisions of a git controlled file
;;  (use-package git-timemachine
;;    :straight t
;;    :ensure t
;;    :bind (("C-x gt" . git-timemachine)))

;; ========
;; parinfer
;; ========
;; parentheses management
(use-package parinfer-rust-mode
  :straight t
  :hook emacs-lisp-mode clojure-mode
  :ensure t
  :init
  (setq parinfer-rust-auto-download t))

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :straight t
  :diminish flycheck-mode
  :init (global-flycheck-mode))
(use-package projectile
  :straight t
  :diminish projectile-mode
  :init (projectile-mode +1)
  :config
  (define-key
    projectile-mode-map
    (kbd "C-c p")
    'projectile-command-map))
(use-package yasnippet
  :straight t
  :diminish yas-minor-mode
  :config (yas-global-mode))
(use-package hydra
  :straight t)

;; ========
;; hideshow
;; ========
;;(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook
(lambda()
  (local-set-key (kbd "C-<right>") 'hs-show-block)
  (local-set-key (kbd "C-<left>")  'hs-hide-block)
  ;;(local-set-key (kbd "C-c <up>")    'hs-hide-all)
  ;;(local-set-key (kbd "C-c <down>")  'hs-show-all)
  (hs-minor-mode t)))
(defun display-code-line-counts (ov)
  (when (eq 'code (overlay-get ov 'hs))
    (overlay-put ov 'help-echo
              (buffer-substring (overlay-start ov)
  		              (overlay-end ov)))))

(setq hs-set-up-overlay 'display-code-line-counts)

(use-package lsp-mode
  :ensure t
  ;; Optional - enable lsp-mode automatically in scala files
  :hook ;;(scala-mode . lsp-deferred)
        (lsp-mode . lsp-lens-mode)
        (lsp-mode . lsp-enable-which-key-integration)
  :config
  ;; Uncomment following section if you would like to tune lsp-mode performance according to
  ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
  ;;       (setq gc-cons-threshold 100000000) ;; 100mb
  ;;       (setq read-process-output-max (* 1024 1024)) ;; 1mb
  ;;       (setq lsp-idle-delay 0.500)
  ;;       (setq lsp-log-io nil)
  (setq lsp-prefer-flymake nil
        lsp-client-packages '(lsp-clients lsp-metals)))

  ;;(use-package company-lsp
  ;;  :ensure t)

  ;; Enable nice rendering of documentation on hover
  ;;   Warning: on some systems this package can reduce your emacs responsiveness significally.
  ;;   (See: https://emacs-lsp.github.io/lsp-mode/page/performance/)
  ;;   In that case you have to not only disable this but also remove from the packages since
  ;;   lsp-mode can activate it automatically.
(use-package lsp-ui
  :straight t
  :ensure t)
(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))
(use-package dap-java
  :straight f
  :ensure nil)

;; for Prolog
(lsp-register-client
 ;;(message "t2b/prolog-lsp-fn()")
  (make-lsp-client
   :new-connection
   (lsp-stdio-connection (list "swipl"
                            "-g" "use_module(library(lsp_server))."
                            "-g" "lsp_server:main"
                            "-t" "halt"
                            "--" "stdio")) 
   :major-modes '(prolog-mode)
   :priority 1
   :multi-root t
   :server-id 'prolog-ls))


(use-package prolog
  :ensure t
  :config (add-hook 'prolog-mode-hook 'lsp))
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode))
                             auto-mode-alist))

;;clojure-mode
(use-package clojure-mode
  :straight t)
  ;;cider
(use-package cider
  :straight t)
  ;;:init
  ;;(add-hook 'cider-repl-mode-hook #'company-mode)
  ;;(add-hook 'cider-mode-hook #'company-mode)
  ;;(add-hook 'clojure-mode-hook #'company-mode))

;; Enable scala-mode for highlighting, indentation and motion commands
(use-package scala-mode
  :straight t
  :ensure t
  :interpreter
  ("scala" . scala-mode))

  ;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
  :straight t
  :ensure t
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
  ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
  (setq sbt:program-options '("-Dsbt.supershell=false")))

  ;; Add metals backend for lsp-mode
(use-package lsp-metals
  :straight t
  :ensure t
  :config
  (add-hook 'scala-mode-hook 'lsp))

(use-package lsp-java
    :ensure t
    :init
    (setq lsp-completion-provider :capf)
    (setq lsp-java-imports-gradle-wrapper-checksums [(:sha256 "c8f4be323109753b6b2de24a5ca9c5ed711270071ac14d0718229cbc77236f48"
                                                      :allowed t)])
    :config
    (add-hook 'java-mode-hook 'lsp))
  ;;Revert back so no long GC pauses during runtime
(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1)

(use-package rustic
  :straight t
  :ensure t
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  (setq rustic-format-on-save t))

(use-package dyalog-mode
  :straight t
  :ensure t
  :init
  ;;(autoload 'dyalog-mode "/path/to/dyalog-mode.el" "Edit Dyalog APL" t)
  ;;(autoload 'dyalog-editor-connect "/path/to/dyalog-mode.el" "Connect Emacs to Dyalog" t)
  (add-to-list 'auto-mode-alist '("\\.apl\\'" . dyalog-mode))
  (add-to-list 'auto-mode-alist '("\\.dyalog$" . dyalog-mode))
)
