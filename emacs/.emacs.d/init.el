; Setup
(package-initialize)

;; directories
(defvar emacs-dir (file-name-directory load-file-name) "The root dir of emacs.")
(defvar emacs-savefile-dir (expand-file-name "savefile" emacs-dir) "The directory where to save additional files")
(defvar emacs-backup-dir (expand-file-name "backups/" emacs-savefile-dir) "The directory where to save backup files")
(defvar emacs-private-dir (expand-file-name "private/" emacs-dir) "Private emacs configurations.")
(defvar emacs-autosave-dir (expand-file-name "auto-save-list/" emacs-savefile-dir))


;; custom settings
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;; load credentials
(load (expand-file-name "credentials.el" emacs-private-dir))

; Emacs initialisation
;; Packages
;; the package manager
(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa" . "http://melpa.org/packages/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/"))
 package-archivE-Priorities '(("melpa-stable" . 1)))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)
(require 'use-package)

;; Interface

;;; Encoding
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8-unix)
;;;; Use hexadecimal instead of octal for quoted-insert (C-q).
(setq read-quoted-char-radix 16)

;;; libraries
(use-package diminish
  :ensure t
  :config
  (diminish 'eldoc-mode)
  (diminish 'auto-fill-function))

;;; Backup configuration
(setq backup-directory-alist `(("." . ,emacs-backup-dir))
      auto-save-file-name-transforms `((".*" ,emacs-autosave-dir t))
      auto-save-list-file-prefix (concat emacs-autosave-dir ".saves-")
      tramp-backup-directory-alist `((".*" . ,emacs-backup-dir))
      tramp-auto-save-directory emacs-autosave-dir)
(setq delete-old-versions t
      backup-by-copying t
      version-control t
      vc-make-backup-files t
      kept-new-versions 5
      kept-old-versions 2)

(defun my-save-buffers ()
  "Save all file-visiting buffers"
  (save-some-buffers t nil))

(add-hook 'focus-out-hook 'my-save-buffers)

;;; Clean the window and environment
(setq
 inhibit-startup-screen t
 initial-scratch-message nil
 initial-major-mode 'org-mode
 create-lockfiles nil
 column-number-mode t
 scroll-error-top-bottom t
 show-paren-delay 0.5
 sentence-end-double-space nil
 require-final-newline t
 visible-bell 1
 ring-bell-function 'ignore)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(use-package powerline
  :config (powerline-default-theme))

(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)
(setq-default fill-column 80)

;; cursor always in the middle
(use-package centered-cursor-mode
  :config (global-centered-cursor-mode +1))

;; global keybindings
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "RET") 'newline-and-indent)
(global-unset-key (kbd "C-;"))
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;;; editing & buffer local variables
(setq-default
 indent-tabs-mode nil
 tab-width 8
 c-basic-offset 2)
(setq tab-always-indent 'complete)

(defalias 'yes-or-no-p 'y-or-n-p)


;;; meaningful names for buffers with the same name
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
;; BROkEN (use-package uniquify)
  ;; :config
  ;; (setq uniquify-buffer-name-style 'forward
  ;;       uniquify-separator "/"
  ;;       uniquify-after-kill-buffer-p t      ; rename after killing uniquified
  ;;       uniquify-ignore-buffers-re "^\\*")) ; don't muck with special buffers

;;; highlight current line
(global-hl-line-mode +1)
(set-face-background 'hl-line "#3e4446")

;;; line numbers
;;; ** TODO switch it off for some modes
(setq linum-format "%4d \u2502 ")
(global-linum-mode t)
(setq solarized-distinct-fringe-background t)

;; additional modes
(electric-indent-mode 0)
(setq echo-keystrokes 0.1
      use-dialog-box nil)
(show-paren-mode t) ;; parenthesis highlight

;; global keybindings
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "RET") 'newline-and-indent)
(global-unset-key (kbd "C-;"))
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; text mode hooks
(add-hook 'text-mode 'turn-on-visual-line-mode)

;; prog mode hooks
(add-hook 'prog-mode
          (lambda ()
            (setq-local comment-auto-fill-only-comments t)
            (auto-fill-mode 1)))

; Packages

;; Helm
(use-package helm
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-split-window-in-side-p           t    ;; See https://github.com/bbatsov/prelude/pull/670 for a detailed
          helm-buffers-fuzzy-matching           t    ;; discussion of these options.
          helm-move-to-line-cycle-in-source     t
          helm-ff-search-library-in-sexp        t
          helm-ff-file-name-history-use-recentf t)
    ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
    ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
    ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
    (global-set-key (kbd "C-c h") 'helm-command-prefix)
    (global-unset-key (kbd "C-x c")))
  :bind-keymap ("C-c h" . helm-command-map)
  :bind (("M-x" . helm-M-x)
         ("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x C-b" . helm-buffers-list)
         ("C-x C-f" . helm-find-files)
         ("C-h f" . helm-apropos)
         ("C-h r" . helm-info-emacs)
         :map helm-command-map
         ("g" . helm-do-grep)
         ("o" . helm-occur))
  :config
  (set-face-attribute 'helm-selection nil 
                      :background "red"   
                      :foreground "black")
  (helm-mode 1)
  (helm-linum-relative-mode 1))

;(define-key helm-command-map (kbd "o")     'helm-occur)
;(define-key helm-command-map (kbd "g")     'helm-do-grep)

;; (set-face-attribute 'helm-selection nil
;;                     :background "red"
;;                     :foreground "black")
;; (global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; (global-set-key (kbd "C-x b") 'helm-mini)
;; (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
;; (global-set-key (kbd "C-h f") 'helm-apropos)
;; (global-set-key (kbd "C-h r") 'helm-info-emacs)

;; project management
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :init (setq projectile-cache-file (expand-file-name "projectile.cache" emacs-savefile-dir))
  :bind-keymap (("C-c p" . projectile-command-map))
  :config
  (projectile-mode t))

(use-package helm-projectile
  :after (helm projectile)
  :init
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))


;; multi cursors editing
(use-package multiple-cursors
  :diminish multiple-cursors-mode
  :bind
  (("C-c m t" . mc/mark-all-like-this)
   ("C-c m m" . mc/mark-all-like-this-dwim)
   ("C-c m c" . mc/edit-lines)
   ("C-c m e" . mc/edit-ends-of-lines)
   ("C-c m a" . mc/edit-beginnings-of-lines)
   ("C-c m n" . mc/mark-next-like-this)
   ("C-c m p" . mc/mark-previous-like-this)
   ("C-c m d" . mc/mark-all-like-this-in-defun)
   ("C-S-<mouse-1>" . mc/add-cursor-on-click)))

;(use-package multiple-cursors
;  :bind-keys (("C-c m c" . mc/edit-lines)
;              ("C-c m <" . mc/mark-next-like-this)
;              ("C-c m >" . mc/mark-prev-like-this)
;              ("C-S-<mouse-l>" mc/add-cursor-on-click)))

;;(global-set-key (kbd "C-c m c") 'mc/edit-lines)

;; org-mode settings
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (progn
    ;;; org todo
    (setq org-log-done t
          org-todo-keywords 
          '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)"))
          org-todo-keyword-faces 
          '(("TODO" . org-warning) 
            ("STARTED"  :foreground "orange" :weight "bold")
            ("WAITING"  :foreground "blue" :weight "bold")
            ("CANCELED" :foreground "forest green")))

    ;;; org agenda
    (setq org-agenda-files (list "~/org/work.org"
                             "~/org/school.org"
                             "~/org/home.org")
          org-agenda-skip-scheduled-if-done t
          org-agenda-skip-deadline-if-done t)

    ;;; org capture
    (setq org-default-notes-file (concat org-directory "/notes.org")
          org-capture-templates
          '(("t" "Tickets" entry 
             (file+headline "~/org/home.org" "Travels")
             (file "~/.emacs.d/org-templates/ticket.orgcaptmpl"))
            ("T" "TODO" entry 
             (file org-default-notes-file)
             (file "~/.emacs.d/org-templates/todo.orgcaptmpl"))
            ("n" "Note" entry (file org-default-notes-file)
             "* %^{Note title}  :NOTE:\n%U\n%?")))

    ;; org refile
    (setq org-refile-use-outline-path 'file
          org-refile-targets 
          '(("~/org/school.org" :maxlevel . 3)
            ("~/org/home.org" :maxlevel . 3)))
    ))

(use-package ob-async
  :after org)
;; (require 'org)
;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)
;; (setq org-log-done t)
;; (setq org-todo-keywords 
;;       '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)")))
;; (setq org-todo-keyword-faces 
;;       '(("TODO" . org-warning) 
;;         ("STARTED"  :foreground "orange" :weight "bold")
;;         ("WAITING"  :foreground "blue" :weight "bold")
;;         ("CANCELED" :foreground "forest green")))

;; ;;; org agenda
;; (setq org-agenda-files (list "~/org/work.org"
;;                              "~/org/school.org"
;;                              "~/org/home.org"))
;; (setq org-agenda-skip-scheduled-if-done t)
;; (setq org-agenda-skip-deadline-if-done t)

;; ;;; org capture
;; (setq org-default-notes-file (concat org-directory "/notes.org"))
;; (define-key global-map "\C-cc" 'org-capture)
;; (setq org-capture-templates
;;       '(("t" "Tickets" entry 
;;          (file+headline "~/org/home.org" "Travels")
;;          (file "~/.emacs.d/org-templates/ticket.orgcaptmpl"))
;;         ("T" "TODO" entry 
;;          (file org-default-notes-file)
;;          (file "~/.emacs.d/org-templates/todo.orgcaptmpl"))
;;         ("n" "Note" entry (file org-default-notes-file)
;;          "* %^{Note title}  :NOTE:\n%U\n%?")))

;; ;; org refile
;; (setq org-refile-use-outline-path 'file)
;; (setq org-refile-targets 
;;       '(("~/org/school.org" :maxlevel . 3)
;;         ("~/org/home.org" :maxlevel . 3)))

(use-package company
  :diminish company-mode
  :hook (prog-mode . company-mode))
;; (require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)

;; mu4e - read email from emacs
(load (expand-file-name "mu4e-conf.el" emacs-private-dir))

;; git diff margins
;; consider removing it if breaks margins or fringes
(use-package diff-hl
  :defines (diff-hl-margin-symbols-alist desktop-minor-mode-table)
  :commands diff-hl-magit-post-refresh
;;  :bind (:map diff-hl-command-map
;;              ("SPC" . diff-hl-mark-hunk))
  :hook ((after-init . global-diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :config
  ;; Highlight on-the-fly
  (diff-hl-flydiff-mode 1)

  ;; Set fringe style
  ;; (setq-default fringes-outside-margins t)
  (unless (display-graphic-p)
    (setq diff-hl-margin-symbols-alist
          '((insert . " ") (delete . " ") (change . " ")
            (unknown . " ") (ignored . " ")))
    ;; Fall back to the display marginem since the fringe is unavailable in tty
    (diff-hl-margin-mode 1)
    ;; Avoid restoring `diff-hl-margin-mode'
    (with-eval-after-load 'desktop
      (add-to-list 'desktop-minor-mode-table
                   '(diff-hl-margin-mode nil))))
  ; Integration with magit
  (with-eval-after-load 'magit
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)))

;; Spell checking
(use-package flyspell
  :ensure t
  :defer 10
  :diminish flyspell-mode
  :preface
  (defvar my-enable-flyspell nil)
  (cond
   ((executable-find "aspell")
    (setq ispell-program-name "aspell")
    (setq my-enable-flyspell t))
   ((executable-find "hunspell")
    (setq ispell-program-name "hunspell")
    (setq ispell-dictionary "en_US")
    (setq my-enable-flyspell t))
   (t
    (message "Neither aspell nor hunspell found")))
  :if my-enable-flyspell
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode)))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :hook (prog-mode . flycheck-mode)
  :config
  (setq flycheck-display-errors-function
        'flycheck-display-error-messages-unless-error-list))

; Languages

;; Docker
(use-package dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;; adding files to cmake mode
(setq load-path (cons (expand-file-name "~/.emacs.d/elpa/cmake-mode-3.10.2") load-path))
(require 'cmake-mode)

;; auctex confs
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(require 'auctex-latexmk)
(auctex-latexmk-setup)
(setq auctex-latexmk-inherit-TeX-PDF-mode t)

;; golang configs
(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  ; (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding                                                      
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)
(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook (lambda ()
  (set (make-local-variable 'company-backends) '(company-go))
  (company-mode)))


; File format
;; CSV
(use-package csv-mode
  :mode ("\\.csv\\'" . csv-mode))

;; Ledger
(use-package ledger-mode
  :mode ("\\.ledger\\'" . ledger-mode)
  :config
  (use-package flycheck-ledger))

;; Markdown
(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode)))

(provide 'init)
;;; init.el ends here
