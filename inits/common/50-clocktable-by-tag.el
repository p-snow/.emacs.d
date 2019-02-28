(require 'org-table)
(require 'org-clock)

(defun clocktable-by-atag/shift-cell (n)
  (let ((str ""))
    (dotimes (i n)
      (setq str (concat str "| ")))
    str))
(defun clocktable-by-atag/insert-tag (params)
  (let ((match (plist-get params :match)))
    (insert "|--\n")
    (insert (format "| %s | *Tag time* |\n" match))
    (let ((total 0))
      (mapcar
       (lambda (file)
         (let ((clock-data (with-current-buffer (find-file-noselect file)
                             (org-clock-get-table-data (buffer-name) params))))
           (when (> (nth 1 clock-data) 0)
             (setq total (+ total (nth 1 clock-data)))
             (insert (format "| | File *%s* | %.2f |\n"
                             (file-name-nondirectory file)
                             (/ (nth 1 clock-data) 60.0)))
             (dolist (entry (nth 2 clock-data))
               (insert (format "| | . %s%s | %s %.2f |\n"
                               (org-clocktable-indent-string (nth 0 entry))
                               (nth 1 entry)
                               (clocktable-by-atag/shift-cell (nth 0 entry))
                               (/ (nth 4 entry) 60.0)))))))
       (org-agenda-files))
      (if (= total 0)
          (save-excursion
            (re-search-backward "*Tag time*")
            (forward-line -1)
            (dotimes (i 2)
              (org-table-kill-row)))
        (save-excursion
          (re-search-backward "*Tag time*")
          (org-table-next-field)
          (org-table-blank-field)
          (insert (format "*%.2f*" (/ total 60.0))))))
    (org-table-align)))
(defun org-dblock-write:clocktable-by-atag (params)
  (insert "| Tag | Headline | Time (h) |\n")
  (insert "|     |          | <r>  |\n")
  (let ((matches
         (org-global-tags-completion-table)))
    (mapcar (lambda (match)
              (let ((match-str (car match)))
                (when (string= (substring match-str 0 3) "AC_")
                  (setq params (plist-put params :match match-str))
                  (clocktable-by-atag/insert-tag params))))
            matches)))

(provide 'clocktable-by-tag)