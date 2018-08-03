;; distinguish TAB and C-i
(setq local-function-key-map (delq '(kp-tab . [9]) local-function-key-map))

;; prevent from executing save-buffers-kill-emacs by mistake
(unbind-key "C-x C-c")
(unbind-key "C-h")
(unbind-key "C-o")

(bind-keys :map global-map
           ("C-h" . backward-delete-char-untabify)
           ("M-SPC" . cycle-spacing)
           ("M-k"   . kill-whole-line)
           ("C-x k" . kill-this-buffer)
           ("C-x O" . maximize-next-window)
           ("M-<up>" . (lambda ()
                         (interactive)
                         (transpose-lines 1)
                         (previous-line 2)))
           ("M-<down>" . (lambda ()
                           (interactive)
                           (next-line 1)
                           (transpose-lines 1)
                           (previous-line 1)))
           ("M-s a" . helm-ag)
           ("M-s g g" . helm-do-ag)
           ("M-s g ." . helm-do-ag-current-dir)
           ("M-s g ~" . helm-do-ag-home)
           ("M-s g f" . helm-do-ag-this-file)
           ("M-s g b" . helm-do-ag-buffers)
           ("M-s g o" . helm-do-ag-org)
           ("M-s g p" . helm-projectile-grep)
           ("M-s d f" . find-dired)
           ("M-s d g" . find-grep-dired)
           ("M-s d n" . find-name-dired)
           ("M-s f p" . helm-projectile-find-file)
           ("C-o" . open-thing-at-point))

(use-package hydra
  :straight t
  :after (yasnippet multiple-cursors)
  :config
  (defhydra hydra-lookup
    (global-map "C-c l"
                :color blue)
    "Lookup"
    ("t" google-translate-enja-or-jaen "translate")
    ("g" xah-lookup-google)
    ("w" xah-lookup-wikipedia)
    ("a" xah-lookup-amazon)
    ("d" xah-lookup-duckduckgo)
    ("e" xah-lookup-eijiro)
    ("l" xah-lookup-weblio)
    ("y" xah-lookup-youtube)
    ("q" nil "quit"))
  (defhydra hydra-multiple-cursors
    (global-map "C-c n"
                :color red)
    "multiple-cursors-hydra"
    ("n"    mc/mark-next-like-this)
    ("N"    mc/skip-to-next-like-this)
    ("M-n"  mc/unmark-next-like-this)
    ("p"    mc/mark-previous-like-this)
    ("P"    mc/skip-to-previous-like-this)
    ("M-p"  mc/unmark-previous-like-this)
    ("e"    mc/edit-lines)
    ("|"    mc/vertical-align)
    ("i"    mc/insert-numbers)
    ("I"    my-mc/insert-numbers)
    ("s"    mc/sort-regions)
    ("S"    mc/reverse-regions)
    ("m"    mc/mark-more-like-this-extended)
    ("a"    mc/mark-all-like-this :exit t)
    ("r"    mc/mark-all-in-region-regexp :exit t)
    ("q"    nil))
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
    ("t" toggle-truncate-lines)
    ("i" adaptive-wrap-prefix-mode)
    ("p" variable-pitch-mode)
    ("w" whitespace-mode)
    ("y" yas-minor-mode)
    ("l" linum-mode)
    ("L" line-number-mode)
    ("C" column-number-mode)
    ("v" view-mode)
    ("h" hs-toggle-hiding)
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
  (defhydra hydra-flycheck (flycheck-mode-map "C-c !"
                                              :color red)
    "Flycheck"
    ("C-c" flycheck-compile)
    ("C-w" flycheck-copy-errors-as-kill)
    ("?" flycheck-describe-checker)
    ("C" flycheck-clear)
    ("H" display-local-help)
    ("V" flycheck-version)
    ("c" flycheck-buffer)
    ("e" flycheck-explain-error-at-point)
    ("d" flycheck-display-error-at-point)
    ("i" flycheck-manual)
    ("l" flycheck-list-errors)
    ("n" flycheck-next-error)
    ("p" flycheck-previous-error)
    ("s" flycheck-select-checker)
    ("v" flycheck-verify-setup)
    ("x" flycheck-disable-checker)
    ("q" nil "quit"))
  (defhydra hydra-launcher (global-map "C-M-j"
                                       :color blue)
    "Launch"
    ("a" ansi-term)
    ("s" shell)
    ("d" dired-jump)
    ("t" twit)
    ("g" magit-status)
    ("w" eww)
    ("m" mu4e)
    ("M" mu4e-alert-view-unread-mails)
    ("j" open-junk-file)
    ("e" elfeed)
    ("q" nil "cancel"))
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
    (:foreign-keys warn
                   :pre (set-face-background 'mode-line "midnight blue")
                   :post (set-face-background 'mode-line "gray10"))
    "Move"
    ("f" scroll-up-line "next")
    ("e" scroll-down-line)
    ("s" org-store-link)
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
    ("R" (responsible-call hlc/readable-func 'redraw-display))
    ("&" (responsible-call hlc/external-func 'redraw-display))
    ("C-o" open-thing-at-point "open")
    ("k" kill-this-buffer "open" :exit t)
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
    ("C-a" seq-home)
    ("C-e" seq-end)
    ("C-SPC" set-mark-command :exit t)
    ("C-," er/expand-region :exit t)
    ("C-s" isearch-forward "isearch" :exit t)
    ("M-a" avy-goto-char-timer "avy" :exit t)))

(use-package restart-emacs
  :straight t
  :after (hydra)
  :config
  (defhydra hydra-exit (global-map "C-M-<backspace>"
                                   :exit t)
    "Exit"
    ("r" restart-emacs)
    ("R" (lambda () (interactive)
           (let ((confirm-kill-processes nil))
             (restart-emacs)))
     "force to restart emacs")
    ("s" save-buffers-kill-emacs)
    ("S" (lambda () (interactive)
           (let ((confirm-kill-processes nil))
             (save-buffers-kill-emacs)))
     "force to save buffers and kill emacs")
    ("k" kill-emacs
     "just kill emacs")
    ("c" nil "cancel")
    ("q" nil "cancel")))
