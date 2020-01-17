;; create a way to distinguish TAB and C-i
(setq local-function-key-map (delq '(kp-tab . [9]) local-function-key-map))

(unbind-key "C-j")
(unbind-key "C-h")
(unbind-key "C-o")

(bind-keys :map global-map
           ("C-j" . newline)
           ("C-h" . backward-delete-char-untabify)
           ("C-y" . yank-and-indent)
           ("M-SPC" . cycle-spacing)
           ("M-k"   . kill-whole-line)
           ("C-c k" . kill-this-buffer)
           ("C-x O" . (lambda ()
                        (interactive)
                        (other-window 1)
                        (delete-other-windows)))
           ("M-<up>" . (lambda ()
                         (interactive)
                         (transpose-lines 1)
                         (previous-line 2)))
           ("M-<down>" . (lambda ()
                           (interactive)
                           (next-line 1)
                           (transpose-lines 1)
                           (previous-line 1)))
           ("C-o" . open-thing-at-point))

(use-package hydra
  :straight t
  :custom
  (hydra-is-helpful nil)
  :config
  (unbind-key "C-x C-t")
  (defhydra hydra-transpose (global-map "C-x C-t"
                                        :color red)
    "Transpose"
    ("c" (lambda ()
           (interactive)
           (transpose-chars 1)
           (backward-char))
     "chars")
    ("w" (lambda ()
           (interactive)
           (transpose-words 1)
           (backward-word))
     "words")
    ("l" (lambda ()
           (interactive)
           (transpose-lines 1)
           (previous-line))
     "lines")
    ("S" (lambda ()
           (interactive)
           (transpose-sentences 1)
           (backward-sentence))
     "sentences")
    ("p" (lambda ()
           (interactive)
           (transpose-paragraphs 1)
           (backward-paragraph))
     "paragraphs")
    ("s" (lambda ()
           (interactive)
           (sp-transpose-sexp)
           (sp-backward-sexp))
     "sexp")
    ("m" transpose-mark "mark")
    ("o" org-transpose-words "Org mode words")
    ("e" org-transpose-elements "Org mode elements")
    ("t" org-table-transpose-table-at-point "Org mode table")
    ("q" nil "cancel" :color blue))
  (defhydra hydra-toggle
    (global-map "C-c t"
                :color pink
                :pre (set-face-background 'mode-line "DarkOrange4")
                :post (set-face-background 'mode-line "gray10"))
    "Toggle"
    ("t" visual-line-mode)
    ("T" toggle-truncate-lines)
    ("i" adaptive-wrap-prefix-mode)
    ("p" variable-pitch-mode)
    ("w" whitespace-mode)
    ("l" display-line-numbers-mode)
    ("L" line-number-mode)
    ("C" column-number-mode)
    ("v" view-mode)
    ("r" rainbow-mode)
    ("\\" toggle-input-method)
    ("f" buffer-face-cycle)
    ("F" toggle-frame-fullscreen)
    ("SPC" pangu-spacing-mode)
    ("q" nil "quit"))
  (defhydra hydra-text-scale
    (global-map "C-M-="
                :color amaranth
                :pre (set-face-background 'mode-line "dark green")
                :post (set-face-background 'mode-line "gray10"))
    "Text Scaling"
    ("C-M-=" text-scale-increase)
    ("+"     text-scale-adjust)
    ("="     text-scale-adjust)
    ("-"     text-scale-adjust)
    ("0"     text-scale-adjust)
    ("q"     nil "quit"))
  (defhydra hydra-launcher (global-map "C-M-j"
                                       :color blue)
    "Launch"
    ("t" ansi-term)
    ("s" shell)
    ("e" (eshell t))
    ("d" dired-jump)
    ("@" twit)
    ("v" magit-status)
    ("a" counsel-linux-app)
    ("g" (lambda ()
           (interactive)
           (let ((eww-launch-in-new-buffer t)
                 (eww-search-prefix "http://www.google.co.jp/search?q="))
             (eww-launch))))
    ("G" (lambda ()
           (interactive)
           (let ((eww-launch-in-new-buffer t))
             (eww-launch))))
    ("m" mu4e)
    ("M" mu4e-alert-view-unread-mails)
    ("j" open-junk-file)
    ("f" elfeed)
    ("o" org-scratch)
    ("p" persp-mode)
    ("q" quickrun)
    ("C-g" nil "cancel"))
  (defhydra hydra-straight (global-map "C-c -"
                                       :color blue)
    "Straight"
    ("c" straight-check-package)
    ("C" straight-check-all)
    ("r" straight-rebuild-package)
    ("R" straight-rebuild-all)
    ("f" straight-fetch-package)
    ("F" straight-fetch-all)
    ("p" straight-pull-package)
    ("p" straight-pull-all)
    ("m" straight-merge-package)
    ("M" straight-merge-all)
    ("n" straight-normalize-package)
    ("N" straight-normalize-all)
    ("u" straight-push-package)
    ("U" straight-push-all)
    ("v" straight-freeze-versions)
    ("V" straight-thaw-versions)
    ("w" straight-watcher-start)
    ("W" straight-watcher-quit)
    ("g" straight-get-recipe)
    ("e" straight-prune-build)
    ("q" nil))
  (defvar hlc/beginning-func nil "")
  (defvar hlc/end-func nil "")
  (defvar hlc/forward-paragraph-func nil "")
  (defvar hlc/backward-paragraph-func nil "")
  (defvar hlc/next-thing-func nil "")
  (defvar hlc/previous-thing-func nil "")
  (defvar hlc/readable-func nil "")
  (defvar hlc/external-func nil "")
  (defvar hlc/quit-func nil "")
  (defvar hlc/enter-func nil "")
  (defvar hlc/backward-page-func nil "")
  (defvar hlc/forward-page-func nil "")
  (defun responsible-call (prefer-func responsible-func)
    (let ((resp-func prefer-func))
      (if (commandp resp-func)
          (funcall resp-func)
        (funcall responsible-func))))
  (defhydra hydra-lazy-control
    (global-map "C-M-m"
                :foreign-keys warn
                :pre (set-face-background 'mode-line "midnight blue")
                :post (set-face-background 'mode-line "gray10"))
    "Move"
    ("f" scroll-up-line "next")
    ("e" scroll-down-line)
    ("s" org-store-link)
    ("l" recenter-top-bottom)
    ("L" copy-line-number)
    ("t" (responsible-call hlc/beginning-func 'beginning-of-buffer))
    ("y" (responsible-call hlc/end-func 'end-of-buffer))
    ("g" (responsible-call hlc/forward-paragraph-func 'forward-paragraph))
    ("r" (responsible-call hlc/backward-paragraph-func 'backward-paragraph))
    ("TAB" (responsible-call
            hlc/next-thing-func (lambda ()
                                  (interactive)
                                  (forward-button 1))))
    ("<backtab>" (responsible-call
                  hlc/previous-thing-func (lambda ()
                                            (interactive)
                                            (backward-button 1))))
    ("C-M-i" (responsible-call
              hlc/previous-thing-func (lambda ()
                                        (interactive)
                                        (backward-button 1))))
    ("R" (responsible-call hlc/readable-func 'redraw-display))
    ("&" (responsible-call hlc/external-func 'redraw-display))
    ("C-o" open-thing-at-point "open")
    ("k" kill-this-buffer "kill buffer" :exit t)
    ("w" nil "exit" :exit t)
    ("q" (responsible-call hlc/quit-func 'quit-window) "quit" :exit t)
    ("j" (responsible-call hlc/enter-func 'forward-page) "enter")
    ("C-j" (responsible-call hlc/enter-func 'forward-page) "enter")
    ("h" (responsible-call hlc/backward-page-func 'backward-page) "page back")
    ("u" (responsible-call hlc/forward-page-func 'forward-page) "page forward")
    ("<up>" previous-line)
    ("<down>" next-line)
    ("<left>" left-char)
    ("<right>" right-char)
    ("C-f" forward-char)
    ("M-f" forward-word)
    ("C-b" backward-char)
    ("M-b" backward-word)
    ("C-n" next-line)
    ("C-p" previous-line)
    ("C-v" scroll-up-command)
    ("M-v" scroll-down-command)
    ("C-a" move-beginning-of-line)
    ("C-e" move-end-of-line)
    ("C-SPC" set-mark-command :exit t)
    ("C-," er/expand-region :exit t)
    ("C-c l" hydra-lookup/body :exit t)
    ("C-s" swiper "swiper" :exit t)
    ("M-a" avy-goto-char-timer "avy" :exit t)))

(use-package restart-emacs
  :straight t
  :after (hydra)
  :config
  (defhydra hydra-exit (global-map "C-M-<delete>"
                                   :exit t)
    "Exit"
    ("r" restart-emacs)
    ("R" (lambda () (interactive)
           (let ((confirm-kill-processes nil))
             (restart-emacs)))
     "force to restart emacs")
    ("k" save-buffers-kill-emacs)
    ("K" (lambda () (interactive)
           (let ((confirm-kill-processes nil))
             (save-buffers-kill-emacs)))
     "force to kill processes")
    ("c" nil "cancel")
    ("C-g" nil "quit")
    ("q" nil "quit")))
