;;; Emacs Load Path
(setq load-path (cons "~/emacs" load-path))
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(autoload 'longlines-mode
  "longlines.el"
  "Minor mode for automatically wrapping long lines." t)
(setq longlines-wrap-follows-window-size t)
(setq default-tab-width 4)
(autoload 'graphviz-dot-mode "graphviz-dot-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.dot$" . graphviz-dot-mode))
(autoload 'turtle-mode "turtle-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.ttl$" . turtle-mode))
;;(add-to-list 'auto-mode-alist '("\\.n3$" . turtle-mode))

(setq inferior-lisp-program
      (let* ((java-path "java")         ; Path to java implementation
                                        ; Extra command-line options
                                        ; to java.
             (java-options "-server")
                                        ; Base directory to Clojure.
                                        ; Change this accordingly.
             (clojure-path "/usr/share/clojure/")
                                        ; The character between
                                        ; elements of your classpath.
             (class-path-delimiter ":")
             (class-path (mapconcat (lambda (s) s)
                                        ; Add other paths to this list
                                        ; if you want to have other
                                        ; things in your classpath.
                                    (list (concat clojure-path "lib/clojure.jar "))
                                    class-path-delimiter)))
        (concat java-path
                " " java-options
                " -cp " class-path
                " clojure.lang.Repl")))
 
;; Require clojure-mode to load and associate it to all .clj files.
(setq load-path (cons "~/emacs" load-path))
;;(require 'clojure-mode)
;;(setq auto-mode-alist
;;      (cons '("\\.clj$" . clojure-mode)
;;            auto-mode-alist))

;; These are extra key defines because I kept typing them.  
;; Within clojure-mode, have Ctrl-x Ctrl-e evaluate the last 
;; expression.
;; Ctrl-c Ctrl-e is also there, because I kept typoing it.
;;(add-hook 'clojure-mode-hook
;;          '(lambda ()
;;             (define-key clojure-mode-map "\C-c\C-e" 'lisp-eval-last-sexp)
;;             (define-key clojure-mode-map "\C-x\C-e" 'lisp-eval-last-sexp)))

;;(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))
;;(autoload 'clojure-mode "clojure-mode" nil t)
;;(require 'clojure-paredit)

(autoload 'n3-mode "n3-mode" "Major mode for OWL or N3 files" t)
(add-to-list 'auto-mode-alist '("\\.n3" . n3-mode))

;; Load auctex
;;(load "auctex.el" nil t t)
;;(load "preview-latex.el" nil t t)

;;(setq TeX-auto-save t)
;;(setq TeX-parse-self t)
;; (setq-default TeX-master nil)

;;(global-set-key         "\C-c\C-v"         'uncomment-region)
(global-set-key         "\C-c\C-v"         'comment-or-uncomment-region)

;; Compile a file with Meta-enter, which puts you over the enter
;; key to redo the previous compile target, which you have to confirm.
;; This keybinding was not used by default.
;; The return key is handled differently than other keys, so I was 
;; forced to "M-<return>" rather than "M-RET" or many other alternative
;; attempts that seemed more obvious.
(global-set-key         (read-kbd-macro "M-<return>") 'compile)

(global-set-key [(tab)] 'smart-tab)
(defun smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
    the minibuffer. Else, if mark is active, indents region. Else if
    point is at the end of a symbol, expands it. Else indents the
    current line."
  (interactive)
  (if (minibufferp)
      (unless (minibuffer-complete)
        (dabbrev-expand nil))
    (if mark-active
        (indent-region (region-beginning)
                       (region-end))
      (if (looking-at "\\_>")
          (dabbrev-expand nil)
        (indent-for-tab-command)))))

;; C-Mode customizations
(setq c-mode-hook
      (function (lambda ()
                  (setq indent-tabs-mode nil)
                  (setq c-indent-level 4)
                  (setq c-basic-offset 4))))
(global-font-lock-mode t)

(setq-default indent-tabs-mode nil)

;;;; The following works for noweb mode (Dave Love), but that
;;;; mode crashes emacs completely (sometimes) when I delete text.
;; (add-hook 'noweb-select-code-mode-hook 'turn-on-font-lock)
;; (add-hook 'noweb-select-doc-mode-hook 'turn-on-font-lock)
;; (setq noweb-doc-mode 'latex-mode)
;; (setq noweb-code-mode 'c-mode)
;; (require 'noweb)
;; (setq auto-mode-alist
;;       (append '(("\\.nw$" . noweb-mode)) auto-mode-alist))

(setq ansi-color-for-comint-mode t)
;;(require 'ipython)

;; wheel mouse
(global-set-key [mouse-4] 'scroll-down)
(global-set-key [mouse-5] 'scroll-up)

;; make 'bell' just flash screen and not make a sound
(setq visible-bell t)

;;;; generic configuration
;; Highlight parens
(setq show-paren-delay 0 show-paren-style 'parenthesis)
(show-paren-mode 1)
(mouse-avoidance-mode 'jump)          ; jump mouse away when typing
(setq scheme-program-name "mzscheme") ; Set name of scheme binary
(setq frame-title-format '("" "%b @ %f")) ; set window title

;; only run if Emacs is run in an X window
(when (equal window-system 'x)
  (set-scroll-bar-mode nil)           ; disable scroll bars
  (tool-bar-mode -1)		      ; disable tool bar
  ;;(put 'scroll-left 'disabled nil)  ; right scroll bar

  ;; enable copy/paste in X
  (setq x-select-enable-clipboard t)
  (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

  ;; Enable mouse scroll wheel in Emacs windows
  ;; The name of your mouse-scroll may differ.
  ;; Use C-h k 'scroll your wheel!' to find the name it is bound to
  (global-set-key [mouse-4] 'scroll-down-one-line)
  (global-set-key [mouse-5] 'scroll-up-one-line))

(when (locate-library "haskell-mode")
  (setq auto-mode-alist
	(append auto-mode-alist
		'(("\\.[hg]s$"  . haskell-mode)
		  ("\\.hi$"     . haskell-mode)
		  ("\\.l[hg]s$" . literate-haskell-mode))))
  (autoload 'haskell-mode "haskell-mode"
    "Major mode for editing Haskell scripts." t)
  (autoload 'literate-haskell-mode "haskell-mode"
    "Major mode for editing literate Haskell scripts." t)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-font-lock)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-ghci t)
  (setq shell-cd-regexp nil))

;;;; change auto-completion to use tab key
;;(defun my-tab-fix ()
;;  (local-set-key [tab] 'indent-or-expand))
;;(add-hook 'c-mode-hook               'my-tab-fix)
;;(add-hook 'sh-mode-hook              'my-tab-fix)
;;(add-hook 'emacs-lisp-mode-hook      'my-tab-fix)
;;(add-hook 'lisp-mode-hook            'my-tab-fix)
;;(add-hook 'inferior-scheme-mode-hook 'my-tab-fix)
;;(add-hook 'haskell-mode-hook         'my-tab-fix)

(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))
(defun my-tab-fix ()
  (local-set-key [tab] 'indent-or-expand))
(add-hook 'c-mode-hook       'my-tab-fix)
(add-hook 'haskell-mode-hook 'my-tab-fix)
(add-hook 'clojure-mode-hook 'my-tab-fix)


;;; Reload Emacs config
;;  By http://www.emacswiki.org/cgi-bin/wiki/JesseWeinstein
(defun reload-.emacs ()
  "Runs load-file on ~/.emacs"
  (interactive)
  (load-file "~/.emacs"))

;;; Scroll line-by-line
;;
;; Used to make scroll-wheel/track-point work.
;; see x11 loader
(defun scroll-up-one-line ()
      (interactive)
      (scroll-up 1))
(defun scroll-down-one-line ()
      (interactive)
      (scroll-down 1))

;; slime setup (with sbcl)
;;(setq inferior-lisp-program "/usr/bin/sbcl")
;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime")
;;(require 'slime)
;;(slime-setup)
;;(add-hook 'lisp-mode-hook
;;	  (lambda () (slime-mode t)
;;	    (local-set-key "\r" 'newline-and-indent)
;;	    (setq lisp-indent-function 'common-lisp-indent-function)
;;	    ;;(setq indent-tabs-mode nil)
;;	    (setq browse-url-browser-function 'browse-url-w3)))
;;(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
;;(setq common-lisp-hyperspec-root "file:///usr/share/doc/hyperspec-7.0/HyperSpec/")
;;(global-set-key "\C-cs" 'slime-selector)
;;(global-set-key [(control tab)] 'slime-complete-symbol)
;;(slime-setup :autodoc t)

;;;; Browser setup, currently handled in above #'add-hook

;; Default-Browser = Firefox
;;(setq browse-url-generic-program "firefox" browse-url-browser-function 'browse-url-generic)
;; Default-Browser = w3
(setq browse-url-browser-function 'browse-url-w3)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "UTF-8")
 '(default-input-method "rfc1345")
 '(global-font-lock-mode t nil (font-lock))
 '(haskell-doc-chop-off-context nil)
 '(haskell-doc-chop-off-fctname t)
 '(haskell-doc-show-global-types t)
 '(haskell-doc-show-prelude nil)
 '(haskell-doc-show-reserved nil)
 '(haskell-doc-show-strategy nil)
 '(haskell-doc-show-user-defined nil)
 '(haskell-ghci-program-args (quote ("-fglasgow-exts" "-fbang-patterns" "-Wall" "-fno-warn-name-shadowing" "-fno-warn-orphans")))
 '(haskell-mode-hook (quote (turn-on-haskell-indent my-tab-fix turn-on-haskell-ghci turn-on-haskell-indent turn-on-haskell-doc-mode)) t)
 '(haskell-program-name "ghci")
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice nil)
 '(js2-highlight-level 3)
 '(js2-use-font-lock-faces t)
 '(make-backup-files nil)
 '(quack-browse-url-browser-function (quote browse-url-lynx-emacs))
 '(safe-local-variable-values (quote ((mmm-classes . embedded-c) (mmm-noweb-doc-mode . latex) (mmm-noweb-code-mode . c) (noweb-doc-mode) (noweb-doc-mode . nroff-mode) (noweb-doc-mode . latex-mode) (mmm-noweb-code-mode . c-mode) (mmm-noweb-code-mode . makefile-mode) (noweb-code-mode . c-mode))))
 '(shell-cd-regexp nil)
 '(show-paren-mode t nil (paren))
 '(slime-complete-symbol-function (quote slime-fuzzy-complete-symbol))
 ;;'(cua-mode t nil (cua-base))
 '(transient-mark-mode t))
;;(require 'color-theme)
;;(setq color-theme-is-global t)
;;(color-theme-initialize)
;; color themes:
;; clarity, salmon-font-lock kingsajz, gnome2, shaman, dark-laptop, marquardt, kingsajz,
;; jonadabian-slate, simple1, charcoal-black, calm-forest, dark-info, deep-blue, gray30
;;(color-theme-clarity)
;;(color-theme-salmon-font-lock)
;;(color-theme-andreas)
(global-set-key [?\C-h] 'delete-backward-char)
(global-set-key [?\M-?] 'help-command)
;;(set-default-font "Bitstream Vera Sans Mono-13")
(setq-default save-place nil)
(put 'downcase-region 'disabled nil)

;; Make text mode the default major mode and turn auto-fill on for text-mode.
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook  'turn-on-auto-fill)

;; Set C-x C-u to undo command.
;;(define-key global-map "\C-x\C-u" 'undo)

;; (global-set-key (kbd "<f9> s") 'delete-trailing-whitespace)
(defun delete-trailing-whitespace-if-confirmed ()
  "Delete all the trailing whitespace across the current buffer,
asking user for confirmation."
  (if (and
       (save-excursion (goto-char (point-min))
		       (re-search-forward "[[:space:]]$" nil t)))
      (delete-trailing-whitespace)))
;; (add-hook 'before-save-hook 'delete-trailing-whitespace-if-confirmed)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(defun count-words-buffer ( )
  "Count the number of words in the current buffer; 
print a message in the minibuffer with the result."
  (interactive)
  (save-excursion
    (let ((count 0))
      (goto-char (point-min))
      (while (< (point) (point-max))
        (forward-word 1)
        (setq count (1+ count)))
      (message "buffer contains %d words." count))))

