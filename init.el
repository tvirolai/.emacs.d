;; -*- lexical-binding: t -*-
(package-initialize)
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))
(put 'magit-clean 'disabled nil)
