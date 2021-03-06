(define custom-activate-default-im-name? #t)
(define custom-preserved-default-im-name 'elatin)
(define default-im-name 'elatin)
(define enabled-im-list '(anthy anthy-utf8 skk tutcode byeoru latin elatin zm wb86 py pyunihan pinyin-big5 viqr ipa-x-sampa look ajax-ime social-ime google-cgiapi-jp baidu-olime-jp))
(define enable-im-switch? #f)
(define switch-im-key '("<Control>Shift_key" "<Shift>Control_key"))
(define switch-im-key? (make-key-predicate '("<Control>Shift_key" "<Shift>Control_key")))
(define switch-im-skip-direct-im? #f)
(define enable-im-toggle? #f)
(define toggle-im-key '("Kanji"))
(define toggle-im-key? (make-key-predicate '("Kanji")))
(define toggle-im-alt-im 'direct)
(define uim-color 'uim-color-uim)
(define candidate-window-style 'vertical)
(define candidate-window-position 'caret)
(define enable-lazy-loading? #t)
(define bridge-show-input-state? #f)
(define bridge-show-with? 'time)
(define bridge-show-input-state-time-length 3)
