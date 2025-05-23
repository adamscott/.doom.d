;;; custom.el -*- lexical-binding: t; -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((apheleia-formatter denofmt-jsonc) (apheleia-formatter denofmt-json)
     (apheleia-formatter denofmt-js)
     (eval progn
      (setq lsp-disabled-clients
            '((rjsx-mode . ts-ls) (typescript-mode . ts-ls)))
      (defun asc-apheleia-formatter-json-hook nil
        (let*
            ((file-name (buffer-file-name))
             (extension (when file-name (file-name-extension file-name))))
          (if (equal extension "jsonc")
              (setq apheleia-formatter '(denofmt-jsonc))
            (setq apheleia-formatter '(denofmt-json)))))
      (add-hook 'json-ts-mode 'asc-apheleia-formatter-json-hook))
     (projectile-project-compilation-cmd . "scons"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
