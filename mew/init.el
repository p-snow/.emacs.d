(setq mew-config-alist
      '((default
          (proto "%")
          (fcc "%sent")
          (imap-trash-folder "%deleted")
          (name "Takayuki Inamori")
          (user "t.inamori@daisychain.jp")
          (mail-domain "daisychain.jp")
          (dcc "t.inamori@daisychain.jp")
          (imap-server "daisychain173.sakura.ne.jp")
          (imap-ssl-port "993")
          (imap-user "t.inamori@daisychain.jp")
          (imap-auth  t)
          (imap-ssl t)
          (smtp-server "daisychain173.sakura.ne.jp")
          (smtp-port "587")
          (smtp-user "t.inamori@daisychain.jp")
          (smtp-auth t)
          (smtp-ssl t)
          (smtp-mail-from "t.inamori@daisychain.jp")
          (signature-file "~/.emacs.d/mew/signature")
          (ssl-verify-level 0)) ;; FIXME
        (gmail
         (proto "%")
         (fcc "%sent")
         (imap-trash-folder "%[Gmail]/ゴミ箱")
         (user "takayuki.inamori")
         (mail-domain "gmail.com")
         (cc "takayuki.inamori@gmail.com")
         (imap-server "imap.gmail.com")
         (imap-ssl-port "993")
         (imap-user "takayuki.inamori@gmail.com")
         (imap-auth  t)
         (imap-ssl t)
         (smtp-server "smtp.gmail.com")
         (smtp-ssl-port "465")
         (smtp-user "takayuki.inamori@gmail.com")
         (smtp-auth t)
         (smtp-ssl t)
         (signature-file "~/.emacs.d/mew/signature.gmail"))))
