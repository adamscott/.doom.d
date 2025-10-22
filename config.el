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

;; Default shell for Emacs
(setq shell-file-name (string-trim (shell-command-to-string "/usr/bin/env -S command -v bash")))

;; Relative display lines
(setq display-line-numbers-type 'relative)

;; Debugging
(after! dap-mode
  (require 'dap-lldb)
  (setq dap-lldb-debug-program '("/usr/bin/lldb-dap")))

;; Mouse scroll
(setq mouse-wheel-tilt-scroll t)

;; Maximize on startup
(add-hook! 'emacs-startup-hook
  (set-frame-parameter frame-initial-frame 'fullscreen 'maximized))

;; clangd
(setq lsp-clients-clangd-args '("-j=3" "--enable-config"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

;; Sibling files (including Objective-C .mm files)
(add-hook! 'objc-mode-hook
  (setq find-sibling-rules '(("/\\([^/]+\\)\\.h\\(h\\|pp\\)?\\'" "\\1.m\\(m\\)?\\'")
                             ("/\\([^/]+\\)\\.m\\(m\\)?\\'" "\\1.h\\(h\\|pp\\)?\\'"))))

;; Alternative activate code signature (LSP) (C-S-SPC doesn't work on macOS)
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
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.cjs\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.mjs\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.cts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.mts\\'" . typescript-mode))

;; ;; Override apheleia-formatters for biome
;; (after! apheleia
;;   (setf (alist-get 'biome apheleia-formatters) '("apheleia-npx" "biome" "format" "--write" "--stdin-file-path" filepath)))

;; Override the new hooks by json-mode
(defun asc-json-mode-auto-mode-list-variable-watcher (_symbol _new-val _operation _where)
  (run-at-time "0.01s" nil
               (lambda ()
                 (asc-add-jsonc-auto-modes))))
(add-variable-watcher 'json-mode-auto-mode-list #'asc-json-mode-auto-mode-list-variable-watcher)

(after! lsp-mode
  ;; Add missing deno.enablePaths
  (defcustom asc-lsp-clients-deno-enable-paths nil
    "Controls if the Deno Language Server is enabled for only specific paths of the workspace folder."
    :group 'lsp-deno
    :risky t
    :type '(repeat string))
  (defcustom asc-lsp-clients-deno-disable-paths nil
    "Controls if the Deno Language Server is disabled for only specific paths of the workspace folder."
    :group 'lsp-deno
    :risky t
    :type '(repeat string))
  (defun asc-lsp-clients-deno--make-init-options-advice (original-func &rest args)
    "Add missing parameter."
    (let ((new-options (plist-put (apply original-func args) :enablePaths asc-lsp-clients-deno-enable-paths)))
      new-options))
  (advice-add 'lsp-clients-deno--make-init-options :around #'asc-lsp-clients-deno--make-init-options-advice)

  ;; Ignore some notifications.
  (defcustom asc-lsp-ignore-notification-rules '("deno/didRefreshDenoConfigurationTree" "deno/didChangeDenoConfiguration" "deno/didUpgradeCheck")
    "Notifications to ignore."
    :group 'lsp-mode
    :risky t
    :type '(repeat string))
  (defun asc-lsp-ignore-notifications-advice (_workspace notification)
    "Ignore deno notification"
    (when (member (plist-get notification :method) asc-lsp-ignore-notification-rules)
      (progn
        (lsp--info (concat "Ignored '" (plist-get notification :method) "' notification"))
        ;; Return t to indicate that the notification is handled.
        t)))
  (advice-add 'lsp--on-notification :before-until #'asc-lsp-ignore-notifications-advice))

;; Vue.js
;; (add-hook 'vue-mode-hook #'lsp!)

;; (setq treesit-language-source-alist
;;       '((vue "https://github.com/ikatyang/tree-sitter-vue")
;;         (css "https://github.com/tree-sitter/tree-sitter-css")
;;         (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
;;         (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))

;; https://github.com/emacs-lsp/lsp-mode/issues/4838#issuecomment-3198461412
;; --- Configure Volar for Hybrid Mode (not necessary since my PR has been merged as it's already the default) ---
(after! lsp-volar
  ;; Disable deprecated and discontinued take over mode
  (setq lsp-volar-take-over-mode nil)
  ;; Configure lsp-mode for Vue 3 Hybrid Mode
  (setq lsp-volar-hybrid-mode t))

;; --- Configure ts-ls to activate for .vue files ---
(after! lsp-mode
  ;; Starts lsp-volar as an add-on to ts-ls
  (setq lsp-volar-as-add-on t)

  ;; 1. Configure ts-ls to use the Vue plugin for context.
  (setq lsp-clients-typescript-plugins
        (vector
         `(:name "@vue/typescript-plugin"
           :location "/usr/lib/node_modules/@vue/language-server"
           :languages ["vue"])))

  ;; 2. Advise the ts-ls activation function to recognize .vue files.
  (advice-add 'lsp-typescript-javascript-tsx-jsx-activate-p :around
              (lambda (orig-fn filename &rest args)
                (message "Checking activation for: %s" filename) ; Debug message
                (or (string-match-p "\\.vue\\'" filename)
                    (apply orig-fn filename args)))))

;; Make sure these classic modes stay.
(add-to-list 'major-mode-remap-alist '(c-mode . c-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-mode))
(add-to-list 'major-mode-remap-alist 
             '(c-or-c++-mode . c-or-c++-mode))

;; Sidecar-locals
(use-package! sidecar-locals
              :init
              (sidecar-locals-mode))

;; Local config (not in repo)
(load! "+local.el")
