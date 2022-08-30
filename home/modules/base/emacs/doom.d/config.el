;;; config.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022
;; Author:  <dash@workspace>
;; Maintainer:  <dash@workspace>
;; Created: August 19, 2022
;; Modified: August 19, 2022
;; Version: 0.0.1
;; Keywords: doom emacs
;; Homepage: https://github.com/mekter/nixos-config
;; Package-Requires: ((doom emacs))
;; This file is not part of GNU Emacs.
;;
;;; Commentary: doom emacs setting on NixOS
;;; Code:

(provide 'config)

;; doom settings
(setq doom-theme 'doom-nord
      doom-neotree-enable-variable-pitch nil
      doom-font (font-spec :family "PragmataPro Mono Liga" :size 18 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Iosevka")
      doom-big-font (font-spec :family "PragmataPro Mono Liga" :size 22))


;; global settings
(setq
  beacon-mode t
  tree-sitter-hl-modes t)

;; treemacs
(after! (:and treemacs ace-window)
  (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers)))

;; org mode
(after! org
  (setq org-directory "~/Documents/org"
        org-todo-keywords '((sequence "TODO(t)" "PROJECT(p)" "WAITING(w)" "SCHEDULED(s)" "CANCELLED(c)" "DOING(n)" "DONE(d)"))
        org-todo-keyword-faces
        '(("TODO" :foreground "#88c0d0")
          ("PROJECT" :foreground "#8fbcbb")
          ("SCHEDULED" :foreground "#5e81ac")
          ("WAITING" :foreground "#d08770")
          ("DOING" :foreground "#ebcb8b")
          ("DONE" :foreground "#a3be8c")
          ("CANCELLED" :foreground "#4c566a"))
        org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✭")))

(after! org-rome
  (setq org-rome-directory "~/Documents/org"))

;; Assumes web-mode and elixir-mode are already set up
;;
(use-package polymode
  :mode ("\.ex$" . poly-elixir-web-mode)
  :config
  (define-hostmode poly-elixir-hostmode :mode 'elixir-mode)
  (define-innermode poly-liveview-expr-elixir-innermode
    :mode 'web-mode
    :head-matcher (rx line-start (* space) "~H" (= 3 (char "\"'")) line-end)
    :tail-matcher (rx line-start (* space) (= 3 (char "\"'")) line-end)
    :head-mode 'host
    :tail-mode 'host
    :allow-nested nil
    :keep-in-mode 'host
    :fallback-mode 'host)
  (define-polymode poly-elixir-web-mode
    :hostmode 'poly-elixir-hostmode
    :innermodes '(poly-liveview-expr-elixir-innermode))
  )

(after! eglot
  (add-to-list 'eglot-server-programs
               '(rescript-mode . ("node"
                                  "$HOME/nixos-config/home/modules/base/emacs/rescript-vscode/extension/server/out/server.js"
                                  "--stdio"))))

(add-hook 'rescript-mode-hook (lambda () (eglot-ensure)))

(setq web-mode-engines-alist '(("elixir" . "\\.ex\\'")))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq auto-tangle-default t))

(setq yas-snippet-dirs (append yas-snippet-dirs
                               '("./snippets")))

;; (use-package corfu
;;   :custom
;;   (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
;;   (corfu-auto t)                 ;; Enable auto completion
;;   (corfu-preselect-first nil)    ;; Disable candidate preselection
;;   ;; Use TAB for cycling, default is `corfu-complete'.
;;   :bind
;;   (:map corfu-map
;;         ("TAB" . corfu-next)
;;         ([tab] . corfu-next)
;;         ("S-TAB" . corfu-previous)
;;         ([backtab] . corfu-previous))

;;   :init
;;   (global-corfu-mode))

;; ;; Add extensions
;; (use-package cape
;;   :init
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev)
;;   (add-to-list 'completion-at-point-functions #'cape-file)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-history)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-keyword)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-tex)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-ispell)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-dict)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-symbol)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-line)
;; )

;;; config.el ends here
