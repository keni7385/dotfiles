;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Andrea Corsini"
      user-mail-address "andrea.corsini@outlook.com")

(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
            '(
              (width . 90)
              ))
      (setq default-frame-alist
            '(
              (width . 90))))
  (progn
    (setq initial-frame-alist '( (tool-bar-lines . 0) ))
    (setq default-frame-alist '( (tool-bar-lines . 0) ))))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "monospace" :size 14 :weight 'semi-light))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-dark)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; org-mode settings
(defun my/style-org () ;;; https://hugocisneros.com/org-config/#todo-faces-and-export-settings
  (setq line-spacing 0.2
        org-pretty-entities t)
  (variable-pitch-mode +1)
  (mapc
   (lambda (face)
     (set-face-attribute face nil :inherit 'fixed-pitch))
   (list 'org-block 'org-table 'org-verbatim 'org-block-begin-line
         'org-block-end-line 'org-meta-line 'org-date 'org-drawer
         'org-property-value 'org-special-keyword 'org-document-info-keyword))
  (mapc
   (lambda (face)
     (set-face-attribute face nil :height 0.8))
   (list 'org-document-info-keyword 'org-block-begin-line 'org-block-end-line
         'org-meta-line 'org-drawer 'org-property-value ))
  (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-level-1 nil :height 1.25)
  (set-face-attribute 'org-level-2 nil :height 1.15 :slant 'italic)
  (set-face-attribute 'org-level-3 nil :height 1.1 :slant 'italic)
  (set-face-attribute 'org-level-4 nil :height 1.05)
  (set-face-attribute 'org-date nil :height 0.8)
  (set-face-attribute 'org-document-title nil :height 1.3)
  (set-face-attribute 'org-ellipsis nil :underline nil)
  )

(add-hook 'org-mode-hook 'my/style-org)

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
    (setq org-default-notes-file "~/org/notes.org"
          org-capture-templates
          '(("t" "Tickets" entry
             (file+headline "~/org/home.org" "Travels")
             (file "~/org/org-templates/ticket.orgcaptmpl"))
            ("T" "TODO" entry
             (file org-default-notes-file)
             (file "~/org/org-templates/todo.orgcaptmpl"))
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

(use-package org-journal
  :ensure t
  :defer t
  :init
  (setq org-journal-prefix-key "C-c j ")
  :config
  (setq org-journal-dir "~/org/journal/"
        org-journal-date-prefix "#+TITLE: "
        org-journal-time-prefix "* "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-date-format "%A, %d %B %Y, W%V"
        org-journal-enable-agenda-integration t))

(use-package deft
  :after org
  :bind ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/org/roam/"))

(c-add-style "my-c++-style"
             '("stroustrup"
               (indent-tabs-mode . nil)
               (c-basic-offset . 4)
               (c-offsets-alist . ((inline-open . 0)
                                   (brace-list-open . 0)
                                   (statement-case-open . +)
                                   (innamespace . -)))))
(defun my-c++-mode-hook ()
  (c-set-style "my-c++-style")
  (auto-fill-mode)
  (c-toggle-auto-hungry-state 1))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

(use-package! org-ref
  :after org
  :defer t
  :init
  (let ((cache-dir (concat doom-cache-dir "org-ref")))
    (unless (file-exists-p cache-dir)
      (make-directory cache-dir t))
    (setq orhc-bibtex-cache-file (concat cache-dir "/orhc-bibtex-cache"))))

(after! org (require 'org-ref))

;; grammar
(setq langtool-default-language "en-GB")
(setq langtool-mother-tongue "it")

;; C++ language server setups
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))
(set-eglot-client! 'cc-mode '("clangd" "-j=3" "--clang-tidy"))
