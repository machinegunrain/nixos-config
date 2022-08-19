
(setq doom-theme 'doom-nord
      doom-neotree-enable-variable-pitch nil
      doom-font (font-spec :family "PragmataPro Mono Liga" :size 18 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Iosevka")
      doom-big-font (font-spec :family "PragmataPro Mono Liga" :size 22))

(setq
  tree-sitter-hl-modes t)

(after! (:and treemacs ace-window)
  (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers)))

(after! org
  (setq org-directory "~/Documents/org")
  (setq org-todo-keywords '((sequence "TODO(t)" "PROJ(p)" "|" "WAIT(w)" "SCHEDULED(s)" "CANCCELLED(c)" "|" "DOING(n)" "DONE(d)"))))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq auto-tangle-default t))
