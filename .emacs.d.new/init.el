;;; Package --- Summary

;;; Commentary:
;; Emacs init file responsible for either loading a pre-compiled configuration
;; file or tangling and loading a literate org configuration file.

;; Don't attempt to find/apply special file handlers to files loaded during
;; startup.

;;; Code

(load (expand-file-name "config" user-emacs-directory))

;;(let ((file-name-handler-alist nil))
;;  (require 'org)
;;  (org-babel-load-file (expand-file-name "config.org" user-emacs-directory)))

;;; init.el ends here
