;;; custom.el -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(lisp-indent-offset nil)
 '(lispy-safe-actions-no-pull-delimiters-into-comments t)
 '(lispy-safe-copy t)
 '(lispy-safe-delete t)
 '(lispy-safe-paste t)
 '(safe-local-variable-values
      '((eval progn (require 'lsp-pyright) (lsp))
           (eval progn (require 'lsp-pyright) (lsp-deferred))
           (eval progn
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (require 'lsp-pyright)
                       (setq lsp-enabled-clients '(nixd-lsp pyright))
                       (setq lsp-pyright-langserver-command "basedpyright")
                       (lsp-workspace-remove-all-folders)
                       (lsp-workspace-folders-add (projectile-project-root)))))
           (eval progn
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (setq lsp-enabled-clients '(nixd-lsp pyright))
                       (setq lsp-pyright-langserver-command
                           "basedpyright-langserver")
                       (lsp-workspace-remove-all-folders)
                       (lsp-workspace-folders-add (projectile-project-root)))))
           (eval progn
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (setq lsp-enabled-clients '(nixd-lsp pyright))
                       (setq lsp-pyright-langserver-command "basedpyright")
                       (lsp-workspace-remove-all-folders)
                       (lsp-workspace-folders-add (projectile-project-root)))))
           (lsp-enabled-clients quote (nixd-lsp pyright))
           (eval progn (message "nil eval done")
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (setq lsp-pyright-langserver-command "basedpyright")
                       (lsp-workspace-remove-all-folders)
                       (lsp-workspace-folders-add (projectile-project-root)))))
           (eval progn (message "nil eval done")
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (setq lsp-pyright-langserver-command "basedpyright")
                       (lsp-workspace-remove-all-folders)
                       (lsp-workspace-folder-add (projectile-project-root)))))
           (eval progn
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (setq lsp-pyright-langserver-command "basedpyright")
                       (lsp-workspace-remove-all-folders)
                       (lsp-workspace-folder-add (projectile-project-root)))))
           (eval progn
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (setq lsp-pyright-langserver-command "basedpyright")
                       (lsp-workspace-remove-all-folders)
                       (let
                           ((current-workspaces
                                (lsp-session-folders (lsp-session))))
                           (message
                               (format "current-workspaces: %s"
                                   current-workspaces))
                           (add-to-list current-workspaces
                               (projectile-project-root))))))
           (eval progn
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (setq lsp-pyright-langserver-command "basedpyright")
                       (lsp-workspace-remove-all-folders)
                       (let
                           ((current-workspaces
                                (lsp-session-folders (lsp-session))))
                           (add-to-list current-workspaces
                               (projectile-project-root))))))
           (eval progn
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (setq lsp-pyright-langserver-command "basedpyright")
                       (lsp-workspace-remove-all-folders)
                       (let
                           ((current-workspaces
                                (lsp-session-folders (lsp-session))))
                           (add-to-list 'current-workspaces
                               (projectile-project-root))))))
           (eval progn
               (add-hook 'lsp-mode-hook
                   (lambda nil "Callback."
                       (lsp-workspace-remove-all-folders)
                       (let
                           ((current-workspaces
                                (lsp-session-folders (lsp-session))))
                           (add-to-list 'current-workspaces
                               (projectile-project-root))))))
           (eval progn
               (add-hook lsp-mode-hook
                   (lambda nil "Callback."
                       (lsp-workspace-remove-all-folders)
                       (let
                           ((current-workspaces
                                (lsp-session-folders (lsp-session))))
                           (add-to-list 'current-workspaces
                               (projectile-project-root))))))
           (eval progn
               (add-hook lsp-mode-hook
                   (lambda nil "Callback."
                       (lsp-workspace-folders-remove-all)
                       (let
                           ((current-workspaces
                                (lsp-session-folders lsp-session-file)))
                           (add-to-list 'current-workspaces
                               (projectile-project-root))))))
           (eval progn) (lsp-disabled-clients quote (pyright))
           (eval progn (message "USE_DIRENV_NWNIGHTS_PATCH set")
               (setenv "USE_DIRENV_NWNIGHTS_PATCH" "1")
               (message
                   (format "new USE_DIRENV_NWNIGHTS_PATCH: %s"
                       (getenv "USE_DIRENV_NWNIGHTS_PATCH"))))
           (eval progn (message "USE_DIRENV_NWNIGHTS_PATCH set")
               (setenv "USE_DIRENV_NWNIGHTS_PATCH" "1")))))
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
