(setq inhibit-startup-message t) ; Disable the startup screen tutorial

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)


;; Set up the visible bell
(setq visible-bell t)

;; See recent files
(recentf-mode 1)

(setq history-length 25)
(savehist-mode 1)

(save-place-mode 1)

(global-auto-revert-mode 1)


;;Dont have to click to change window, only pass through
(setq mouse-autoselect-window t)

;; Font Configuration and theme ----------------------------------------------------------

; configuration for the font
(set-face-attribute 'default nil :font "Hack Nerd Font Mono" :height 140) 

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Hack Nerd Font Propo" :height 140)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Hack Nerd Font Propo" :height 120 :weight 'regular)


; set the theme
(load-theme 'wombat) 


;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(set-frame-parameter (selected-frame) 'alpha '(94 . 85))
(add-to-list 'default-frame-alist '(alpha . (94 . 85)))

;; Package Manager Configuration -----------------------------------------------

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Add line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; install this package too see logs of my actions
(use-package command-log-mode) 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d"
     "0c83e0b50946e39e237769ad368a08f2cd1c854ccbcd1a01d39fdce4d6f86478"
     "9d5124bef86c2348d7d4774ca384ae7b6027ff7f6eb3c401378e298ce605f83a"
     "8d3ef5ff6273f2a552152c7febc40eabca26bae05bd12bc85062e2dc224cde9a"
     "ff24d14f5f7d355f47d53fd016565ed128bf3af30eb7ce8cae307ee4fe7f3fd0"
     "dfb1c8b5bfa040b042b4ef660d0aab48ef2e89ee719a1f24a4629a0c5ed769e8"
     default))
 '(package-selected-packages
   '(all-the-icons-dired calfw calfw-org command-log-mode company-box
			 counsel-projectile dired-hide-dotfiles
			 dired-open dired-single doom-modeline
			 doom-themes eterm-256color evil-collection
			 evil-nerd-commenter general git-command
			 haskell-mode helpful ivy-rich jedi
			 lsp-haskell lsp-ivy lsp-jedi lsp-metals
			 lsp-ui magit modus-themes no-littering
			 nyan-mode org-appear org-bullets org-download
			 pdf-tools rainbow-delimiters ruff-format
			 treemacs-evil treemacs-projectile
			 typescript-mode visual-fill-column which-key)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:height 1.9 :weight bold))))
 '(org-level-2 ((t (:height 1.6 :weight bold))))
 '(org-level-3 ((t (:height 1.4 :weight bold))))
 '(org-level-4 ((t (:height 1.2))))
 '(org-level-5 ((t (:height 1.0))))
 '(org-level-6 ((t (:height 1.0))))
 '(org-level-7 ((t (:height 1.0))))
 '(org-level-8 ((t (:height 1.0)))))

(add-hook 'org-mode-hook
          (lambda ()
            (setq fill-column 200)  ;; Establecer el ancho para Org-mode
            (auto-fill-mode 1)))     ;; Activar el modo de llenado automático

(setq org-hide-emphasis-markers t)

 ;;LISTAS EN ORG MEJORADAS
(defun my/org-list-insert-item ()
  "Insert a new list item or continue list on RET."
  (interactive)
  (if (org-at-item-p)
      (org-insert-item)
    (newline)))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "RET") 'my/org-list-insert-item))

;; TAB funcione para listas y bloques de codigo
(setq org-cycle-separator-lines -1) ;; Permite la indentación más precisa con TAB


;;Visor pdfs

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))


(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))

(add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))


;; Ivy Configuration -----------------------------------------------------------


 ;; install ivy package
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	                ;this bind are inside of the buffer map
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

;Add nyan cat
(nyan-mode 1)

;Package for customize the mode line
(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-height 38) ;; Altura de la mode-line

  ;; Activar iconos
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)

  ;; Estilo de nombre de archivo
  (setq doom-modeline-buffer-file-name-style 'truncate-with-project)
  
  :hook (after-init . doom-modeline-mode))

  
;;Pacakage to add more themes (to sse themes do counsel-load-themes or load-themes)
(use-package doom-themes
  :init (load-theme 'doom-plain-dark t)
  :config
  ;; Personalizar el color del cursor
  (setq-default cursor-type 'bar)
  (set-cursor-color "#FFFFFF"))

;; Package for more colors in the languages programs mode
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;; Package for tell u what u can do after put a keyboard shortcut
(use-package which-key
  :defer 0
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))



;;Package for obtain info of ivy commands in the minibuffer menu
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


;;Package for include and config counsel command
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))



;;Package for better and more detailed output in the emacs help
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Key Binding Configuration ---------------------------------------------------

;;Package to create like a menu with keybindings submenus
(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme"))) ;map of the menu



;; Package for setup a Vim like usage (with C-w i can operate with wintows)
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
  (evil-global-set-key 'motion "t" 'evil-next-visual-line)
  (evil-global-set-key 'motion "n" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))
  (setq-default evil-shift-width 4) ; Configura el ancho de desplazamiento para que coincida con el teclado Dvorak
  (setq-default evil-want-C-i-jump nil) ; Desactiva la asignación de TAB para saltar
  (define-key evil-normal-state-map (kbd "s") 'evil-forward-char) ; Asigna 'f' para moverse hacia adelante
  (define-key evil-normal-state-map (kbd "h") 'evil-backward-char) ; Asigna 't' para moverse hacia atrás
  (define-key evil-normal-state-map (kbd "t") 'evil-next-line) ; Asigna 'n' para moverse a la siguiente línea
  (define-key evil-normal-state-map (kbd "n") 'evil-previous-line) ; Asigna 's' para moverse a la línea anterior


;;Package to add more things to evil?
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-nerd-commenter
  :bind("M-/" . evilnc-comment-or-uncomment-lines))


;;Package for text scale (command is hydra-text-scale/body)
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text")) ;Bind to general menu


;; Projectile Configuration ----------------------------------------------------

;; Package for have some features to manage projects (to create a new project use projectile-add-know-project)
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)              ;Bind to open the menu
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))


;; Magit Configuration ---------------------------------------------------------


;;Package to make easier to use git in emacs
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Org Mode Configuration ------------------------------------------------------

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))


(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Hack Nerd Font Propo" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
	'("~/agenda-emacs/agenda.org")))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)


  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))
  
  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
    `(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/Downloads/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/Projects/Code/emacs-from-scratch/OrgFiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))


(use-package calfw
  :ensure t)

(use-package calfw-org
  :ensure t
  :config
  ;; Atajo de teclado para abrir el calendario mensual
  (global-set-key (kbd "C-c c") 'cfw:open-org-calendar))

(use-package calfw
    :ensure t)
  
 (use-package calfw-org
    :ensure t
    :config
    ;; Atajo de teclado para abrir el calendario mensual
    (global-set-key (kbd "C-c c") 'cfw:open-org-calendar))

(use-package org-bullets 
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))

(setq org-confirm-babel-evaluate nil)

(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))


;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/Downloads/emacs.org")) ;Guarda automaticante de este archivo y lo guarda en el especificado en este archivo
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-startup-with-inline-images t)

;;Capturas en los archivos .org
(use-package org-download
  :ensure t
  :config
  (add-hook 'dired-mode-hook 'org-download-enable))


(use-package org-download
  :ensure t
  :config
  ;; Función personalizada para forzar el directorio de imágenes
  (defun my/org-download-set-dir ()
   ; "Fuerza siempre el directorio fijo para guardar las imágenes."
    (setq-local org-download-image-dir "~/apuntes-uni/imagenes/"))

  ;; Habilitar org-download en org-mode y aplicar la función personalizada
  (add-hook 'org-mode-hook 'my/org-download-set-dir)
  (add-hook 'org-mode-hook 'org-download-enable)

  ;; Atajo de teclado para pegar la imagen del portapapeles
  (define-key org-mode-map (kbd "C-c i") 'org-download-clipboard))







;;; LSP Configuration ------------------------------------------------------



(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

(use-package typescript-mode      ;;Antes de usarlo hay que descargarlo en emacs-lsp-Github
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(use-package lsp-mode
  :ensure t
  :hook (python-mode . lsp-deferred))

(use-package lsp-jedi
  :ensure t
  :after lsp-mode
  :config (setq lsp-jedi-server-command '("~/.emacs.d/.venvs/default/bin/jedi-language-server")))


(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))


;;; Terminal Configuration ------------------------------------------------------

(use-package term
  :config
  (setq explicit-shell-file-name "fish") ;; Change this to zsh, etc
  ;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

  ;; Match the default Bash shell prompt.  Update this if you have a custom prompt
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))


;(use-package eterm-256color
;  :hook (term-mode . eterm-256color-mode))

;;; Dired^ Configuration ------------------------------------------------------

;;; Dired^ Configuration ------------------------------------------------------

;;; Dired Configuration ------------------------------------------------------

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :config
  ;; Configuración segura y portable
  (setq dired-listing-switches "-alh")  ;; evita errores de parseo
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "s" 'dired-find-file
    "u" 'dired-unmark
    "t" 'dired-next-line))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-open
  :config
  ;; Doesn't work as expected!
  ;;(add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("png" . "feh")
                                ("mkv" . "mpv"))))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))


(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq lsp-log-io t)

;;Default compile python
(add-hook 'python-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (format "python3 %s" (shell-quote-argument (buffer-file-name))))))




;; Fix para el error "Invalid face box" en macOS
(with-eval-after-load 'doom-themes
  (set-face-attribute 'mode-line nil :box '(:line-width -1 :color "#5B6268")))


(defun reload-init-file ()
  "Recarga el archivo init.el."
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "C-c r") 'reload-init-file)




(use-package lsp-mode
  :ensure t
  :hook ((scala-mode . lsp))
  :config
  (setq lsp-prefer-flymake nil))

(use-package lsp-metals
  :ensure t
  :after scala-mode
  :custom
  (lsp-metals-server-command "metals"))

(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)$")


(defun scala-build-or-run ()
  "Usa Metals para compilar el proyecto actual."
  (interactive)
  (lsp-metals-build-connect)
  (lsp-metals-build-targets))

(with-eval-after-load 'scala-mode
  (define-key scala-mode-map (kbd "C-c C-b") 'scala-build-or-run))

(defun scala-compile-or-run-file ()
  "Si hay build.sbt usa sbt, si no ejecuta el archivo con scala directamente."
  (interactive)
  (let* ((project-root (locate-dominating-file default-directory "build.sbt"))
         (object-name (file-name-sans-extension
                       (file-name-nondirectory buffer-file-name))))
    (if project-root
        (let ((default-directory project-root))
          (compile (format "sbt \"runMain %s\"" object-name)))
      (compile (format "scala %s" buffer-file-name)))))


(with-eval-after-load 'scala-mode
  (define-key scala-mode-map (kbd "C-c C-c") 'scala-compile-or-run-file))



;; ------------Treemacs

;; Treemacs: navegador de archivos tipo árbol
(use-package treemacs
  :ensure t
  :defer t
  :bind
  (("C-x t t" . treemacs)          ;; abrir/cerrar treemacs
   ("C-x t 1" . treemacs-delete-other-windows)
   ("C-x t B" . treemacs-bookmark)
   ("C-x t C-t" . treemacs-find-file))
  :config
  (setq treemacs-width 35
        treemacs-is-never-other-window t
        treemacs-collapse-dirs 3
        treemacs-silent-refresh t
        treemacs-filewatch-mode t
        treemacs-follow-after-init t))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(global-set-key (kbd "M-t") 'treemacs)

;; ------------------------------------------------------------
;; 🔧 FIX DEFINITIVO: Dired en macOS (evita "Listing directory failed")
;; ------------------------------------------------------------
(when (eq system-type 'darwin)
  ;; Desactiva el uso de ls --dired (BSD ls no lo soporta en macOS)
  (setq dired-use-ls-dired nil)
  ;; Asegura que se use el ls correcto
  (setq insert-directory-program "/bin/ls")
  ;; Limpia el formato de listado para evitar opciones incompatibles
  (setq dired-listing-switches "-alGh"))
  
;; ------------ Haskell con LSP estable (sin bucles) ------------------
(use-package haskell-mode
  :ensure t
  :hook ((haskell-mode . lsp-deferred))
  :config
  ;; Evita que se use Cabal al compilar desde Emacs
  (setq haskell-process-type 'none)
  (setq haskell-stylish-on-save t)
  (defun haskell-compile-this-file ()
    "Compila el archivo actual con GHC directamente, sin Cabal."
    (interactive)
    (let* ((file (buffer-file-name))
           (output (file-name-sans-extension
                    (file-name-nondirectory file))))
      (compile (format "ghc -o %s %s && ./%s" output file output))))
  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile-this-file))

;; --- Configuración de LSP-Haskell (fix para macOS y HLS 2.12)
(use-package lsp-haskell
  :after lsp-mode
  :config
  (setq lsp-haskell-server-path "/opt/homebrew/bin/haskell-language-server-wrapper")
  (setq lsp-haskell-server-wrapper-function (lambda (argv) argv))
  (setq lsp-haskell-formatting-provider "ormolu")
  (setq lsp-haskell-plugin-tactics-global-on nil)
  (setq lsp-haskell-plugin-ghcide-type-lenses-global-on nil)
  (setq lsp-haskell-plugin-ghcide-type-lenses-config-mode nil)
  (setq lsp-haskell-plugin-ghcide-completions-config-snippets-on nil))

;; --- BACKUPS Y AUTOGUARDADOS FUERA DEL PROYECTO -----------------------------

;; Desactivar los backups y autosaves locales
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)


;; --- REDIRIGIR ARCHIVOS .class A UNA CARPETA TEMPORAL -----------------------

(defun scala-run ()
  "Compila y ejecuta el archivo Scala actual en un directorio temporal."
  (interactive)
  (let* ((src (buffer-file-name))
         (build-dir (expand-file-name "~/.emacs-scala-build")))
    (unless (file-directory-p build-dir)
      (make-directory build-dir t))
    (compile (format "scalac -d %s %s && scala -cp %s %s"
                     build-dir
                     src
                     build-dir
                     (file-name-sans-extension
                      (file-name-nondirectory src))))))


;; --- OCULTAR ARCHIVOS INNECESARIOS EN DIRED -------------------------------
(use-package dired-x
  :ensure nil
  :config
  (add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))
  (setq dired-omit-files
        (concat dired-omit-files "\\|\\.class$\\|~$\\|^#.*#$")))