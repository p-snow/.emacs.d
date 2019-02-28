(add-hook 'sh-mode-hook
          (lambda ()
            (defvar sh-basic-offset)
            (setq sh-basic-offset 2)
            (defvar sh-indentation)
            (setq sh-indentation 2)
            (defvar sh-indent-after-if)
            (setq sh-indent-after-if '+)
            (defvar sh-indent-for-case-label)
            (setq sh-indent-for-case-label 0)
            (defvar sh-indent-for-case-alt)
            (setq sh-indent-for-case-alt '+)
            (setq-local helm-dash-docsets helm-dash-docsets-sh-mode)))
(delight 'sh-mode " SH")