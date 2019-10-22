(use-package eww
  :delight " EW"
  :custom
  (shr-width -1)
  :config
  (bind-keys :map eww-mode-map
             ("C-j" . eww-follow-link)
             ("["   . eww-back-url)
             ("]"   . eww-next-url)
             :map eww-bookmark-mode-map
             ("C-j" . eww-bookmark-browse))
  (setq shr-use-fonts nil)
  (setq shr-image-animate nil)
  (setq eww-search-prefix "http://www.google.co.jp/search?q=")
  (add-hook 'eww-mode-hook
            (lambda ()
              (buffer-face-set 'readable)
              (whitespace-mode -1)
              (eww-lazy-control)))
  (add-hook 'eww-after-render-hook
            (lambda ()
              (setq-local truncate-lines nil)
              (eww-goto-contents)))
  (bind-keys :map eww-mode-map
             ("C-M-m" . eww-lazy-control))
  (add-hook 'eww-after-render-hook #'eww-set-buffer-name-from-page-title)
  (setq eww-header-line-format nil)
  ;; redefine shr-fill-xxx to disable inserting line break
  (defun shr-fill-text (text) text)
  (defun shr-fill-lines (start end) nil)
  (defun shr-fill-line () nil))

(defun eww-goto-contents ()
  (let ((url (eww-current-url)))
    (when (string-match (concat (regexp-quote
                                 "https://eow.alc.co.jp/search?q=") "\\([^&]+\\)") url)
      (let* ((search-word-escape (match-string 1 url))
             (search-word (org-link-unescape search-word-escape)))
        (search-forward (format "* %s" search-word))
        (beginning-of-line 1)
        (recenter-top-bottom 0)))
    (when (string-match-p (regexp-quote "https://www.weblio.jp/content/") url)
      (forward-line 44))))

(defun eww-lazy-control ()
  "Lazy control in EWW."
  (interactive)
  (setq-local hlc/beginning-func 'eww-goto-heading)
  (setq-local hlc/forward-paragraph-func
              (lambda ()
                (interactive)
                (forward-paragraph 2)
                (backward-paragraph 1)
                (forward-line 1)
                (recenter-top-bottom 0)))
  (setq-local hlc/backward-paragraph-func
              (lambda ()
                (interactive)
                (backward-paragraph 2)
                (forward-paragraph 1)
                (backward-paragraph 1)
                (forward-line 1)
                (recenter-top-bottom 0)))
  (setq-local hlc/next-thing-func 'shr-next-link)
  (setq-local hlc/previous-thing-func 'shr-previous-link)
  (setq-local hlc/readable-func 'eww-readable)
  (setq-local hlc/external-func 'eww-browse-with-external-browser)
  (setq-local hlc/enter-func 'eww-follow-link)
  (setq-local hlc/backward-page-func 'eww-back-url)
  (setq-local hlc/forward-page-func 'eww-forward-url)
  (hydra-lazy-control/body))

(defvar eww-launch-in-new-buffer nil
  "If non-nil, create a new buffer and open in it when `eww-launch` is called.")
(defun eww-launch ()
  "Open url or request query to searching engine by calling `eww`.

If `eww-launch-in-new-buffer` is non-nil,
this function force to create a new buffer and display rendering results in it."
  (interactive)
  (if eww-launch-in-new-buffer
      (progn
        (advice-add 'eww :around #'open-in-new-buffer)
        (call-interactively 'eww)
        (advice-remove 'eww #'open-in-new-buffer))
    (call-interactively 'eww)))
(defun open-in-new-buffer (orig-fun &rest args)
  "If this function is added as an advice to ORIG-FUN,
a new buffer will be created and
the original function will be called in it.

ARGS will be passed to the original function."
  (with-temp-buffer
    (apply orig-fun args)))

;; insert line break so one line terminates right edge of the window
;; this setting is optimal for my font size (shr-width)
;; http://emacs.rubikitch.com/eww-width/
(defun shr-insert-document--for-eww (&rest them)
  (let ((shr-width (* 2 (/ (x-display-pixel-width) (font-get (face-attribute 'readable :font) :size)))))
    (apply them)))
(defun eww-display-html--fill-column (&rest them)
  (advice-add 'shr-insert-document :around 'shr-insert-document--for-eww)
  (unwind-protect
      (apply them)
    (advice-remove 'shr-insert-document 'shr-insert-document--for-eww)))
(advice-add 'eww-display-html :around 'eww-display-html--fill-column)

;; control site color
(defvar eww-disable-colorize t)
(defun shr-colorize-region--disable (orig start end fg &optional bg &rest _)
  (unless eww-disable-colorize
    (funcall orig start end fg bg)))
(advice-add 'shr-colorize-region :around 'shr-colorize-region--disable)
(defun eww-disable-color ()
  "disable original site color"
  (interactive)
  (setq-local eww-disable-colorize t)
  (eww-reload))
(defun eww-enable-color ()
  "enable original site color"
  (interactive)
  (setq-local eww-disable-colorize nil)
  (eww-reload))

;; control displaying images
(defvar eww-display-images t)
(defun eww-toggle-images ()
  (interactive)
  (setq eww-display-images (not eww-display-images))
  (if eww-display-images
      (setq-local shr-put-image-function 'shr-put-image)
    (setq-local shr-put-image-function 'shr-put-image-alt))
  (eww-reload))
(defun shr-put-image-alt (spec alt &optional flags)
  (insert alt))

(defun eww-set-buffer-name-from-page-title ()
  "Set EWW buffer name by extracting page title."
  (interactive)
  (let ((source (plist-get eww-data :source))
        (dom nil))
    (with-temp-buffer
      (let ((source-file (make-temp-file "source-"))
            (coding-system-for-write 'utf-8-unix))
        (insert source)
        (write-region (point-min) (point-max) source-file nil)
        (erase-buffer)
        (call-process "extract_headings" source-file t)
        (delete-file source-file)
        (setq dom (libxml-parse-xml-region (point-min) (point-max)))))
    (rename-buffer (format "eww %s" (dom-attr (car (dom-by-tag dom 'headings)) 'title)) t)))

(defun eww-goto-heading ()
  "Set point to the heading line."
  (interactive)
  (let* ((url (plist-get eww-data :url))
         (source (plist-get eww-data :source))
         (heading
          (if (stringp source)
              (with-temp-buffer
                (let ((source-file (make-temp-file "source-"))
                      (coding-system-for-write 'utf-8-unix))
                  (insert source)
                  (write-region (point-min) (point-max) source-file nil)
                  (erase-buffer)
                  (call-process "extract_headings" source-file t)
                  (delete-file source-file)
                  (print (buffer-substring-no-properties (point-min) (point-max)))))
            (shell-command-to-string
             (mapconcat #'identity
                        (if (string-suffix-p ".html" url)
                            (list "extract_headings" url)
                          (list "curl" "-s" url "|" "extract_headings"))))))
         (min-strlen 4)
         (max-strlen (* 2 (/ (x-display-pixel-width) (font-get (face-attribute 'readable :font) :size)))))
    ;; search substring of heading by decrementing searching string
    (cl-labels ((search-heading (trunc-len)
                                (if (>= trunc-len min-strlen)
                                    (if-let* ((trunc-heading (string-trim-right (truncate-string-to-width heading trunc-len)))
                                              (match-pos (search-forward trunc-heading nil t 1)))
                                        (progn
                                          (message "heading: %s" trunc-heading)
                                          match-pos)
                                      (search-heading (1- trunc-len)))
                                  nil)))
      (when-let ((match-pos (search-heading max-strlen)))
        (beginning-of-line)
        (recenter-top-bottom 0)))))

(defun eww-goto-top ()
  "Set point to the line which contain either title or h1 text of the html file."
  (interactive)
  (let* ((html-string (prog2 (eww-view-source)
                          (string-as-multibyte (string-as-unibyte (buffer-string)))
                        (kill-buffer)))
         (dom (dom-sanitize (with-temp-buffer
                              (erase-buffer)
                              (insert html-string)
                              (libxml-parse-html-region (point-min) (point-max)))))
         (title (car (dom-extract-title dom)))
         (h1 (car (dom-extract-h1 dom))))
    (loop for top-str in `(,title ,h1) until
          (<
           (point)
           (let* ((strlen-min 6)
                  (match-pos
                   (loop for strlen downfrom (* 2 (/ (x-display-pixel-width) (font-get (face-attribute 'readable :font) :size))) to strlen-min
                         for str = top-str then (string-trim-right (truncate-string-to-width top-str strlen))
                         for p = (search-forward str nil t 1)
                         if (integerp p) return p)))
             (if (integerp match-pos)
                 (progn (goto-char match-pos)
                        (beginning-of-line)
                        (recenter-top-bottom 0)
                        (point))
               (point)))))))

(defun dom-sanitize (dom &optional result)
  (push (nreverse
         (cl-reduce (lambda (acc object)
                      (cond
                       ((and (stringp object)
                             (not (string-match-p "[[:graph:]]" object)))
                        acc)
                       ((or (atom object)
                            (consp (car object)))
                        (cons object acc))
                       (t
                        (dom-sanitize object acc))))
                    dom :initial-value nil))
        result))

(defun dom-extract-title (dom &optional result)
  (nreverse
   (cl-reduce (lambda (acc object)
                (pcase object
                  (`(title ,_ ,ttl)
                   (cons ttl acc))
                  ((or (pred atom)
                       (guard (consp (car object))))
                   acc)
                  (_
                   (dom-extract-title object acc))))
              dom :initial-value result)))

(defun dom-extract-h1 (dom &optional result)
  (nreverse
   (cl-reduce (lambda (acc object)
                (pcase object
                  (`(h1 ,_ ,h1-text)
                   (cons h1-text acc))
                  ((or (pred atom)
                       (guard (consp (car object))))
                   acc)
                  (_
                   (dom-extract-h1 object acc))))
              dom :initial-value result)))
