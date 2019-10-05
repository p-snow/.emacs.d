(use-package ruby-mode
  :straight t
  :delight " RB"
  :mode (("\\.rb$"   . ruby-mode)
         ("Capfile$" . ruby-mode)
         ("Gemfile$" . ruby-mode))
  :interpreter (("ruby"    . ruby-mode)
                ("rbx"     . ruby-mode)
                ("jruby"   . ruby-mode))
  :after (sequential-command-config)
  :config
  (setq ruby-indent-level 2)
  (setq ruby-insert-encoding-magic-comment nil)
  (add-hook 'ruby-mode-hook
            '(lambda ()
               (setq-local flycheck-checker 'ruby-rubocop)
               (setq-local counsel-dash-docsets '("Ruby"))))
  (add-to-list 'hs-special-modes-alist
               `(ruby-mode
                 ,(rx (or "def" "class" "module" "do" "if" "{" "[")) ; Block start
                 ,(rx (or "}" "]" "end"))                       ; Block end
                 ,(rx (or "#" "=begin"))                        ; Comment start
                 ruby-forward-sexp nil))
  ;; sequential command
  (define-sequential-command ruby-seq-home
    beginning-of-line
    ruby-beginning-of-block
    ruby-beginning-of-defun
    beginning-of-buffer
    seq-return)
  (define-sequential-command ruby-seq-end
    end-of-line
    ruby-end-of-block
    ;; ruby-end-of-defun ; FIXME: cause error
    end-of-buffer
    seq-return)
  (bind-keys :map ruby-mode-map
             ("C-a" . ruby-seq-home)
             ("C-e" . ruby-seq-end)))

(use-package inf-ruby
  :straight t
  :config
  (setq inf-ruby-default-implementation "pry")
  (add-to-list 'inf-ruby-implementations '("pry" . "pry"))
  (setq inf-ruby-eval-binding "Pry.toplevel_binding")
  (setq inf-ruby-first-prompt-pattern "^\\[[0-9]+\\] pry\\((.*)\\)> *")
  (setq inf-ruby-prompt-pattern "^\\[[0-9]+\\] pry\\((.*)\\)[>*\"'] *"))

(use-package yaml-mode
  :straight t)
