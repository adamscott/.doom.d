;;; custom.el -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
    '((eval progn
        (setq lsp-disabled-clients
          '((rjsx-mode . ts-ls) (typescript-mode . ts-ls)))
        (setq asc-lsp-clients-deno-enable-paths '("./platform/web" "./misc")))
       (eval progn
         (setq lsp-disabled-clients
           '((rjsx-mode . ts-ls) (typescript-mode . ts-ls))))
       (projectile-project-compilation-cmd . "scons"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
