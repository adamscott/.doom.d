;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; HERE AS A REMINDER.
;; (add-to-list '+format-on-save-disabled-modes 'emacs-lisp-mode)

;; Default shell for Emacs.
(if (featurep :system 'macos) 
    (progn
      (setq shell-file-name (string-trim (shell-command-to-string "/usr/bin/env -S command -v zsh")))
      (setq shell-file-name (string-trim (shell-command-to-string "/usr/bin/env -S command -v bash")))
      (setq doom-symbol-font "Apple Symbols")))

;; Relative display lines.
(setq display-line-numbers-type 'relative)

;; Debugging.
(after! dap-mode
        (require 'dap-lldb)
        (setq dap-lldb-debug-program '("/usr/bin/lldb-dap")))

;; Mouse scroll.
(setq mouse-wheel-tilt-scroll t)

;; Maximize on startup.
(add-hook! 'emacs-startup-hook :append (lambda ()
                                         "Set as fullscreen and maximized."
                                         (set-frame-parameter frame-initial-frame 'fullscreen-restore 'maximized)
                                         (set-frame-parameter frame-initial-frame 'fullscreen 'fullboth)))

;; Lisp formatting
;; (use-package! thunk)
(defun +asc/lisp-indent-function (&rest args)
  "Apply sly-common-lisp-indent-function, but load it only JIT."
  (use-package sly)
  (apply #'sly-common-lisp-indent-function args))
(setq lisp-indent-function '+asc/lisp-indent-function)

;; Add `SPC o c` shortcut.
(defun +asc-compilation/toggle ()
  (interactive)
  (let ((buffer (get-buffer "*compilation*")))
    (if buffer
        (if (+popup-buffer-p buffer)
            (+popup/close (get-buffer-window buffer) 'force)
            (+popup-buffer buffer)
            (let ((window (get-buffer-window buffer)))
              (if window
                  (select-window window)
                  (message "couldn't find window of *compilation*"))))
        (message "*compilation* doesn't exist yet."))))

(map! :leader
      (:prefix "o" :desc "Toggle compilation popup" "c" #'+asc-compilation/toggle))

;; clangd
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

;; Alternative activate code signature (LSP) (C-S-SPC doesn't work on macOS).
(map! :after lsp-mode
      :map lsp-mode-map
      :leader
      :desc "Activates the signature"
      "c SPC" #'lsp-signature-activate)

(defun asc-add-jsonc-auto-modes ()
  (let ((auto-modes '(("\\.jsonc\\'" . jsonc-mode)
                      ("tsconfig.*?\\.json\\'" . jsonc-mode)
                      ("jsconfig.*?\\.json\\'" . jsonc-mode))))
    (dolist (auto-mode auto-modes)
      (setq auto-mode-alist (delete auto-mode auto-mode-alist))
      (add-to-list 'auto-mode-alist auto-mode))))

(asc-add-jsonc-auto-modes)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.cjs\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.cts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.mts\\'" . typescript-mode))

;; Override the new hooks by json-mode.
(defun asc-json-mode-auto-mode-list-variable-watcher (_symbol _new-val _operation _where)
  (run-at-time "0.01s" nil
               (lambda ()
                 (asc-add-jsonc-auto-modes))))
(add-variable-watcher 'json-mode-auto-mode-list #'asc-json-mode-auto-mode-list-variable-watcher)

;; Add SCons files to 'auto-mode-alist.
(add-to-list 'auto-mode-alist '("\\SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("\\SConscript" . python-mode))
(add-to-list 'auto-mode-alist '("\\SCsub" . python-mode)) ;; Godot variant.

;; Add GDScript files to 'auto-mode-alist.
(add-to-list 'auto-mode-alist '("\\.gd\\'" . gdscript-mode)) ;; Add gdscript-formatter.

(after! lsp-mode
        ;; https://github.com/emacs-lsp/lsp-mode/issues/4313
        (lsp-dependency 'typescript
                        '(:npm :package "typescript@<7"
                          :path "tsserver")))

;; Make sure these classic modes stay.
(add-to-list 'major-mode-remap-alist '(c-mode . c-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-mode))
(add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-mode))

;; Set default lisp/elisp formatter.
;; (add-hook! 'apheleia-global-mode-hook :append (lambda ()
;;                                                 "Add lisp to 'apheleia-mode-alist"
;;                                                 (with-eval-after-load 'apheleia
;;                                                   (setf (alist-get 'emacs-lisp-mode apheleia-mode-alist) '(lisp-indent))
;;                                                   (setf (alist-get 'common-lisp-mode apheleia-mode-alist) '(lisp-indent)))))

;; Dired custom maps.
(map! :map dired-mode-map
      "C-Q" #'dired-do-query-replace-regexp)

;; Bind :x to save and close the current buffer (instead of save and quit.)
(defun +asc/save-and-close-window-and-maybe-buffer ()
  "Save and close a window. If the buffer is now unused, close the buffer too."
  (progn
    ))
(after! evil
        (evil-ex-define-cmd "x" '+asc/save-and-close-window-and-maybe-buffer))

;; Sidecar-locals.
(use-package! sidecar-locals
              :init
              (sidecar-locals-mode))

;; mise.el
(use-package! mise
              :init
              (global-mise-mode))

;; Fish.
(use-package! fish-mode)

;; Corfu.
(after! corfu
        (setq corfu-auto-delay 0.2))

;; Apheleia formatters.
(set-formatter! 'djlint `(,@(if (executable-find "djlint") '("djlint") '("uv" "run" "djlint")) "-" "--reformat") :modes '(web-mode))
(set-formatter! 'djlint-jinja `(,@(if (executable-find "djlint") '("djlint") '("uv" "run" "djlint")) "--profile=jinja" "-" "--reformat") :modes '(web-mode))
(set-formatter! 'gdscript-formatter '("gdscript-formatter" "--reorder-code" "--stdout") :modes '(gdscript-mode gdscript-ts-mode))
(set-formatter! 'prettier-vue '("apheleia-npx" "prettier" "--stdin-filepath" filepath "--parser=vue"
                                (when apheleia-formatters-respect-indent-level
                                  (unless
                                      (or
                                       (cl-loop
                                        for file in
                                        '(".prettierrc" ".prettierrc.json"
                                          ".prettierrc.yml" ".prettierrc.yaml"
                                          ".prettierrc.json5" ".prettierrc.js"
                                          "prettier.config.js" ".prettierrc.mjs"
                                          "prettier.config.mjs" ".prettierrc.cjs"
                                          "prettier.config.cjs" ".prettierrc.toml")
                                        if (locate-dominating-file default-directory file)
                                        return t)
                                       (when-let* ((pkg (locate-dominating-file default-directory "package.json")))
                                                  (progn
                                                    (require 'json)
                                                    (let ((json-key-type 'alist))
                                                      (assq 'prettier (json-read-file
                                                                       (expand-file-name "package.json" pkg)))))))
                                    (apheleia-formatters-indent "--use-tabs" "--tab-width")))))

(defun apheleia-mode-alist-remove-after-init (symbol newval operation where)
  "Remove some values from 'apheleia-formatters"
  (when (and (eq operation 'set) (not (eq (assq 'gdscript-mode newval) nil)))
    (remove-variable-watcher symbol #'apheleia-mode-alist-remove-after-init)
    (let ((finalvalue (assq-delete-all 'gdscript-mode (assq-delete-all 'gdscript-ts-mode newval))))
      (progn
        (add-to-list 'finalvalue '(gdscript-mode . gdscript-formatter))
        (add-to-list 'finalvalue '(gdscript-ts-mode . gdscript-formatter))
        (run-with-timer 0 nil
                        (lambda ()
                          (set symbol finalvalue)))))))
(add-variable-watcher 'apheleia-mode-alist #'apheleia-mode-alist-remove-after-init)

(use-package! uv)

;; Make sure that the path is the same that in a shell.
(use-package! exec-path-from-shell
              :init
              (progn
                (message "exec-path-from-shell init!")
                (when (or (memq window-system '(mac ns x pgtk))
                          (daemonp))
                  (progn
                    (message "window-system!!")
                    (exec-path-from-shell-initialize)))))

(after! projectile
        (let ((home-dir (expand-file-name "~")))
          (add-to-list 'projectile-ignored-projects home-dir)))

;; Local config (not in repo).
(load! "+local.el")
