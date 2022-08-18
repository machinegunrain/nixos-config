
(setq doom-theme 'doom-nord
      doom-neotree-enable-variable-pitch nil
      doom-font (font-spec :family "PragmataPro Mono Liga" :size 18 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Iosevka")
      doom-big-font (font-spec :family "PragmataPro Mono Liga" :size 22))

(setq
  +tree-sitter-hl-enabled-modes t)

(after! (:and treemacs ace-window)
  (setq aw-ignored-buffers (delq 'treemacs-mode aw-ignored-buffers)))
