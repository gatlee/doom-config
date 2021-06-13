;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Used for differing settings between different devices

(defun device-eval (&rest l)
  (or
   (pcase (system-name)
     ("gatlee" (plist-get l ':pc))
     ("gatarch" (plist-get l ':x250))
     ("localhost" (plist-get l ':phone))
     ("nixos" (plist-get l ':nixos)))
   (plist-get l ':default)))

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Gatlee Kaw"
      user-mail-address "gatlee.kaw@gmail.com")

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
(setq doom-font (device-eval
                 :default (font-spec :family "Andale Mono" :size 16)
                 :default (font-spec :family "Andale Mono" :size 18)))

(setq gat/light-theme (device-eval
                        :default 'doom-gruvbox-light))
(setq gat/dark-theme (device-eval
                      :default 'doom-rouge))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme gat/dark-theme)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/OrgFiles/")
(setq org-roam-directory "~/OrgFiles/")
(setq org-roam-db-location "~/OrgFiles/org-roam.db")
(setq org-agenda-files (list "~/OrgFiles/"))
(setq +org-capture-todo-file "~/OrgFiles/inbox.org")
(setq deft-directory "~/OrgFiles")
(setq org-archive-location (concat org-directory "/archived.org::"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
(setq doom-localleader-key ",")

(map! :leader :g "SPC" 'counsel-M-x)
(map! :leader :g "f t" 'treemacs)

(map! :leader :g "o s" 'shell)

(defun c-mode-hooks ()
  (map! :leader :n "c m" 'evil-make)
)

(add-hook 'c-mode-hook 'c-mode-hooks)

(defun ivy-mode-hooks ()
  (map! :g "C-RET" 'ivy-immediate-done)
)

(add-hook 'ivy-mode-hook 'ivy-mode-hooks)

;; ORG Config
(setq org-hide-emphasis-markers t)


(map! :after org
      :map org-mode-map
      :localleader
      "a c" #'org-screenshot-take)

;; (set-face-attribute 'default nil :family "Iosevka" :height 130)
;; (set-face-attribute 'fixed-pitch nil :family "Iosevka")
(set-face-attribute 'variable-pitch nil :family "Overpass")
(after! org (set-face-attribute 'org-roam-link nil :slant 'italic))
(after! org (set-face-attribute 'org-roam-link-current nil :slant 'italic))


(setq org-superstar-headline-bullets-list
  '("◉" "❍" "✸" "✿"))

(defun gat/toggle-theme ()
  "Toggles between poet themes"
  (interactive)
  (if (custom-theme-enabled-p gat/dark-theme)
      (load-theme gat/light-theme)
    (load-theme gat/dark-theme)))

(map! :leader "tT" 'gat/toggle-theme)
(require 'tramp)
(add-to-list 'tramp-methods
             '("yadm"
               (tramp-login-program "yadm")
               (tramp-login-args (("enter")))
               (tramp-login-env (("SHELL") ("/bin/sh")))
               (tramp-remote-shell "/bin/sh")
               (tramp-remote-shell-args ("-c"))))
(map! :leader "g." (cmd! (magit-status  "/yadm::")))

(map! :map 'org-mode-map
      :n "-" 'org-cycle-list-bullet)


(add-hook 'text-mode-hook #'mixed-pitch-mode)

;; Opens org file image and edits it in pinta
(defun edit-image-at-point ()
  (interactive)
  (let ((filename (elt (split-string (thing-at-point 'filename)":") 1)))
  (start-process "pinta" nil "pinta" filename)))


;; Set to null so that the fallback directories are run
(setq org-download-image-dir nil)

;; Move border
(load "~/.doom.d/move-border")
(device-eval
  :pc nil ;;(load "~/.doom.d/splash")
  :x250 nil ;;(load "~/.doom.d/splash")
  :default nil)

(map! :g "M-K" 'move-border-up)
(map! :g "M-J" 'move-border-down)
(map! :g "M-H" 'move-border-left)
(map! :g "M-L" 'move-border-right)

;; Move up and down windows
(map! :g "M-k" 'evil-window-up)
(map! :g "M-j" 'evil-window-down)
(map! :g "M-h" 'evil-window-left)
(map! :g "M-l" 'evil-window-right)

;;Clojure Configuration
(map! :map 'cider-repl-mode-map
      :i "C-k" 'cider-repl-backward-input
      :i "C-j" 'cider-repl-forward-input)

;; Slurp and Barf :D
(map! :map 'clojure-mode-map
      :n ">)" 'paredit-forward-slurp-sexp
      :n "<(" 'paredit-backward-slurp-sexp
      :n "<)" 'paredit-forward-barf-sexp
      :n ">(" 'paredit-backward-barf-sexp
      :i "C-h" 'paredit-forward-barf-sexp
      :i "C-l" 'paredit-forward-slurp-sexp)

(after! which-key
  (setq which-key-idle-delay 0.25)
  (setq which-key-idle-secondary-delay 0))

;; Add convenient org roam mapping
(map! (:when (featurep! :lang org +roam))
      :leader
      (:prefix ("r" . "org-roam")
       :desc "Switch to buffer" "b" #'org-roam-switch-to-buffer
       :desc "Org Roam Capture" "c" #'org-roam-capture
       :desc "Find File"        "f" #'org-roam-find-file
       :desc "Show graph"       "g" #'org-roam-graph
       :desc "Insert"           "i" #'org-roam-insert
       :desc "Org Roam"         "r" #'org-roam))

(setq display-line-numbers-type 'relative)


(map! :leader :desc "Next Visual Mode" "t v" #'next-visual-mode)
(define-minor-mode next-visual-mode
  "Minor mode for moving up via visualy"
  :global nil :lighter "nil" :init-value nil
  (if next-visual-mode
      (map! :n "j" #'evil-next-visual-line
            :n "k" #'evil-previous-visual-line)
    (map! :n "j" #'evil-next-line
          :n "k" #'evil-previous-line)))


(add-hook! org-mode-hook #'next-visual-mode)
(setq +doom-dashboard--width 120)

;;Mu4e stuff
(set-email-account! "gatmek1"
                    '((user-mail-address . "gatmek1@gmail.com")
                      (mu4e-sent-folder       . "/gmail/[Gmail]/Sent Mail")
                      (mu4e-drafts-folder     . "/gmail/[Gmail]/Drafts")
                      (mu4e-trash-folder      . "/gmail/[Gmail]/Trash")
                      (mu4e-refile-folder     . "/gmail/[Gmail]/All Mail")
                      (mu4e-compose-signature . "-- Gatlee"))
                    t)
(map!
 :leader "o u" #'undo-tree-visualize
 :leader "p s" #'+ivy/project-search
 :leader "p S" #'projectile-save-project-buffers
 :leader "p w" #'projectile-save-project-buffers)

(map! :after ivy
      :map ivy-mode-map
      :g "<C-return>" #'ivy-immediate-done)

(map! :g "<S-f6>" #'lsp-rename)

(setq prescient-filter-method '(literal regexp initialism fuzzy))
(use-package org-drill :after org)

(setq org-roam-server-host "localhost"
      org-roam-server-port 8000
      org-roam-server-export-inline-images t
      org-roam-server-authenticate nil
      org-roam-server-label-truncate t
      org-roam-server-label-truncate-length 60
      org-roam-server-label-wrap-length 20)

(defmacro gat/run-vlc-command
    (&rest command)
  (append
   `(start-process "vlc" nil
                   "dbus-send"
                   "--print-reply"
                   "--session"
                   "--dest=org.mpris.MediaPlayer2.vlc"
                   "/org/mpris/MediaPlayer2")
   command))


(defun gat/vlc-rewind-ten ()
  (interactive)
  (gat/run-vlc-command "org.mpris.MediaPlayer2.Player.Seek" "int64:-10000000"))

(defun gat/vlc-ff-ten ()
  (interactive)
  (gat/run-vlc-command "org.mpris.MediaPlayer2.Player.Seek" "int64:10000000"))

(defun gat/vlc-pause ()
  (interactive)
  (gat/run-vlc-command "org.mpris.MediaPlayer2.Player.PlayPause"))

(map! :leader (:prefix ("v" . "vlc")
               :desc "⏯" "k" #'gat/vlc-pause
               :desc "⏩" "l" #'gat/vlc-ff-ten
               :desc "⏪" "j" #'gat/vlc-rewind-ten
               :desc "vlc/hydra" "v" #'hydra-vlc/body))

(defhydra hydra-vlc ()
  ("j" #'gat/vlc-rewind-ten "⏪")
  ("k" #'gat/vlc-pause "⏯")
  ("l" #'gat/vlc-ff-ten "⏩"))


(map! :in "M-f" #'avy-goto-char-2)

(setq! org-log-done 'time)

;; Nov settings
(add-hook! 'nov-mode-hook #'visual-line-mode)

(setq tramp-shell-prompt-pattern  "\\(?:^\\|\r\\)[^]#$%>\n]*#?[]#$%>].* *\\(\\[[0-9;]*[a-zA-Z] *\\)*")


;; Atlassian Functions
(defun gat/open-ticket ()
  (interactive)
  (let ((prefix "https://bulldog.internal.atlassian.com/browse/")
        (key (thing-at-point 'symbol)))

    (if (string-prefix-p "QUICK-" key)
        (browse-url-default-macosx-browser (concat prefix key))
      (message (concat key " is not a valid ticket")))))

(if IS-MAC
    (map! :leader (:prefix ("j" . "job")
                   :desc "open ticket in jira" "t" #'gat/open-ticket)))


(map! :after org
      :map org-mode-map
      :localleader
      "S" #'org-save-all-org-buffers)

(map! :after pdf-view
      :map pdf-view-mode-map
      "i" #'org-noter-insert-note)

(setq! evil-undo-system 'undo-tree)
