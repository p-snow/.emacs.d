;; language and locale
(set-language-environment "Japanese")
(setq system-time-locale "C")

;; coding system
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)

;; prefer-coding-system take effect equally to follows
(set-buffer-file-coding-system 'utf-8-unix)
(set-file-name-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(setq locale-coding-system 'utf-8-unix)

;; file
(setq custom-file (format "%s/custom.el" user-emacs-directory))
(setq make-backup-files nil)
(setq auto-save-interval 100)
(setq auto-save-timeout 10)
(setq delete-auto-save-files t)
(setq delete-by-moving-to-trash t)
(auto-compression-mode t)
(custom-set-variables '(enable-remote-dir-locals t))
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file
      (concat user-emacs-directory "places"))
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; string
(setq text-quoting-style 'straight) ; avoid curved quote in docstring (emacs25)

;; region
(delete-selection-mode t)

;; mark
(setq set-mark-command-repeat-pop t)
(setq mark-ring-max 32)

;; autorevert
(global-auto-revert-mode t)
(setq auto-revert-verbose nil)
(diminish 'global-auto-revert-mode)
(diminish 'auto-revert-mode)

;; reveal-mode
(reveal-mode 0)
(diminish 'reveal-mode "rv")

;; etc
(setq history-delete-duplicates t)
(setq history-length 1000)
(setq gc-cons-threshold (* 10 gc-cons-threshold))
(setq message-log-max 10000)
(setq shell-command-switch "-c")
(setq undo-outer-limit 64000000)

;; for buffer-face-mode
(defface readable nil nil)
(defface recognizable nil nil)
(defface visible nil nil)
(defface outline nil nil)
(defface coding nil nil)
(defface selecting nil nil)
(defface calendar nil nil)
(defvar buffer-face-list '(default readable recognizable visible outline coding selecting))
(defun buffer-face-cycle ()
  "docstring"
  (interactive)
  (let* ((current-face (if buffer-face-mode-face buffer-face-mode-face (car buffer-face-list)))
         (current-face-index (cl-position current-face buffer-face-list))
         (next-face (nth (% (+ current-face-index 1) (length buffer-face-list))
                         buffer-face-list)))
    (buffer-face-set next-face)
    (message "%s" next-face)))
(buffer-face-mode 1)
(diminish 'buffer-face-mode)

;; use onyx theme (original)
(setq custom-theme-directory
      (locate-user-emacs-file "themes"))
(load-theme 'onyx t)

;; frame
;; fit the frame to full screen if Emacs has GUI
(when window-system
  (add-hook 'after-init-hook
            (lambda ()
              (set-frame-parameter nil 'fullscreen 'fullboth))))

;; window elements
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

;; display
(setq inhibit-startup-screen t)
(setq-default bidi-display-reordering nil)

;; scroll
(setq scroll-step 1)
(setq next-screen-context-lines 2)

;; buffer
(setq initial-scratch-message "")

;; mini buffer
(fset 'yes-or-no-p 'y-or-n-p)
(savehist-mode 1)

;; cursor
(add-hook 'focus-in-hook
          (lambda ()
            (interactive)
            (blink-cursor-mode 1)))

;; message box
(defalias 'message-box 'message)
(setq use-dialog-box nil)

;; text
(setq-default indent-tabs-mode nil)
(setq text-scale-mode-step 1.0625)

;; fill
(setq-default fill-column 80)

;; alarm
(setq visible-bell nil)
