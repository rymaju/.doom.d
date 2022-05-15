;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ryan Jung"
      user-mail-address "ryan.matthew.jung@gmail.com")

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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-spacegrey)


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

;; Global
(map! "C-z" 'nil) ;; Does nothing instead of immediately exiting emacs


;; Tide (Typescript / TSX)
;; quickfix keybinding + tide formatting config
(after! tide
  (setq typescript-indent-level 2)
  (map! :map tide-mode-map "C-c l ." 'tide-fix)
  (setq tide-always-show-documentation t)
  (setq tide-format-options '(:tabSize 2 :indentSize 2)))

;; Git Commit Setup Hook, Conventional Commits + Emojis

;; A CommitType is ∈ COMMIT-TYPES
(defvar COMMIT-TYPES
      '("✨ feat"       ;; "Another hackneyed word; like factor it usually adds nothing to the sentence in which it occurs." - Elements of Style, Strunk & White
        "🐛 fix"
        "📚 docs"
        "💎 style"
        "♻️ reorganize" ;; *not* "refactor", which is a misused and overloaded word
        "🚀 perf"
        "🧪 test"
        "📦 build"
        "👷 ci"
        "🔧 chore"
        "🔍 typo"
        "✍️ rename" 
        "none"))

;; insert-emoji-conventional-commit-type : _ -> _
;; Effect: Inserts the selected commit type into the bugger
(defun insert-emoji-conventional-commit-type ()
  "Select a common emoji+conventional commit type to insert into the buffer."
  (interactive)
  (let ((choice (completing-read "Choose:" COMMIT-TYPES nil t)))
    (and (not (equal choice "none"))
         (insert (concat choice ": ")))))

(after! magit
  (add-hook 'git-commit-setup-hook 'insert-emoji-conventional-commit-type))

;; Use the "command" key as meta (M-) on Mac
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

(setq doom-font (font-spec :family "Fira Code" :size 16)
      doom-variable-pitch-font (font-spec :family "Fira Sans"))

;; Whenever you open emacs, the window is maximized to screen width & height
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; To get Java code completion to work in meghanada mode without the disable/enable hack
;; https://github.com/lollerz/doom-emacs/commit/ea3b0a0d3a160061e2ee9e2bfc83422d13220ddf
(set-company-backend! 'java-mode '(company-meghanada :separate company-dabbrev-code))

(defun prettier-format-current-file ()
  "Formats the current file using prettier (must be installed globally)"
  (interactive)
  (shell-command (format "prettier --write %s" (shell-quote-argument (buffer-file-name)))))

(setq global-prettify-symbols-mode 'nil)
