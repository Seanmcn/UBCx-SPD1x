;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname final-project-text-editor) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;; =========================================
;; Constants

(define WIDTH 350)
(define HEIGHT 30)

(define FONT-SIZE 14)
(define FONT-COLOR "BLACK") 

(define CURSOR (rectangle 1 20 "solid" "black")) 
(define MTS (empty-scene WIDTH HEIGHT))

;; =========================================
;; Data defintions: 

(define-struct editor (text cursorPos))
;; Editor is (make-editor String Natural)
;; interp. (make-editor text cursorPos) is a text editor with text 'text' and cursor postion 'cursorPos'
;;        text is the currently inputted text
;;        cursorPos is the x position of the cursor

(define E1 (make-editor ""    0 ) )    ; editor is empty, cursor at start  
(define E2 (make-editor "tester" 0 ) ) ; editor is '|tester' with cursor at start 
(define E3 (make-editor "tester" 3 ) ) ; editor is 'tes|ter' with cursor in middle
(define E4 (make-editor "tester" 6 ) ) ; editor is 'tester' with cursor at end  

#;
(define (fn-for-editor e)
  (... (editor-text e)
       (editor-cursorPos e)))

;; Template rules used
;; - compound: 2 fields


;; =========================================
;; Functions:

;; Editor -> Editor
;; called to load the text editor; start with (main (make-editor "" 0))
;; no tests for main function
(define (main e)
  (big-bang e
            (to-draw render-editor)  ; Editor -> Editor
            (on-key handle-key)))    ; Editor KeyEvent -> Editor


;; Editor -> Editor
;; render the current editor
(check-expect (render-editor (make-editor "tester" 0)) 
              (overlay/align "left" "middle"  
                             (beside  CURSOR
                                      (text "tes" FONT-SIZE FONT-COLOR) 
                                      (text "ter" FONT-SIZE FONT-COLOR))  
                             MTS)) ; Cursor at start of editor
(check-expect (render-editor (make-editor "tester" 3)) 
              (overlay/align "left" "middle"  
                             (beside (text "tes" FONT-SIZE FONT-COLOR)  
                                     CURSOR  
                                     (text "ter" FONT-SIZE FONT-COLOR))  
                             MTS)) ; Cursor in middle of editor
(check-expect (render-editor (make-editor "tester" 6)) 
              (overlay/align "left" "middle"  
                             (beside  (text "tes" FONT-SIZE FONT-COLOR) 
                                      (text "ter" FONT-SIZE FONT-COLOR)
                                      CURSOR)  
                             MTS)) ; Cursor at end of editor

;; (define (render-editor e) e) ;stub

;; took template from Editor
(define (render-editor e)   
  (overlay/align "left"  
                 "middle"  
                 (beside (text (text-left e) FONT-SIZE FONT-COLOR)  
                         CURSOR  
                         (text (text-right e) FONT-SIZE FONT-COLOR))  
                 MTS))  

;; Editor -> Editor
;; handle key input to the editor
(check-expect (handle-key (make-editor "tester" 6 ) "left" ) (make-editor "tester" 5 ))  ; left: cursor move left 
(check-expect (handle-key (make-editor "tester" 2 ) "right" ) (make-editor "tester" 3 ))  ; right: cursor move right
(check-expect (handle-key (make-editor "tester" 6 ) "\b"  ) (make-editor "teste" 5 ))     ; backspace : remove last character
(check-expect (handle-key (make-editor "tester" 6 ) "s"  ) (make-editor "testers" 7 ))     ; s : adds s to the string

;; (define (handle-key e key) e) ; stub

;; took template from Editor

(define (handle-key e key)  
  (cond [(key=? key "left") (cursor-move-left e)]  
        [(key=? key "right")   (cursor-move-right e)]  
        [(key=? key "\b")      (char-backspace e)]     
        [else (char-add key e)]  
        )  
  )  

;; Editor -> Editor
;; Returns the text that should be to the left of the cursor
(check-expect (text-left E1) "");  
(check-expect (text-left E2) "");  
(check-expect (text-left E3) "tes");  

;; (define (text-left e) e) ; stub

;; took template from Editor

(define (text-left e) (if (= (editor-cursorPos e) 0 ) "" (substring (editor-text e) 0 (editor-cursorPos e)))) 

;; Editor -> Editor
;; Returns the text that should be to the right of the cursor
(check-expect (text-right E1) "");  
(check-expect (text-right E2) "tester");  
(check-expect (text-right E3) "ter");  

;; (define (text-right ED1) "") ; stub   

;; took template from Editor    

(define (text-right e) (if (= (editor-cursorPos e) 0 )(editor-text e) (substring (editor-text e) (editor-cursorPos e) (string-length (editor-text e))))) 

;; Editor -> Editor
;; Moves the cursor one space to the left
(check-expect (cursor-move-left E1) (make-editor "" 0))  
(check-expect (cursor-move-left E2) (make-editor "tester" 0 ))  
(check-expect (cursor-move-left E3) (make-editor "tester" 2 ))  

;; (define cursor-move-left e) e) ;stub

;; Template from Editor  
(define (cursor-move-left e) (if (= (editor-cursorPos e) 0) e (make-editor (editor-text e) (- (editor-cursorPos e) 1))))   

;; Editor -> Editor
;; Moves the cursor one space to the right
(check-expect (cursor-move-right E1) (make-editor ""    0 ))  
(check-expect (cursor-move-right E2) (make-editor "tester" 1 ))  
(check-expect (cursor-move-right E3) (make-editor "tester" 4 ))   

; (define (cursor-move-right e) e) ;stub

;; took template from Editor  

(define (cursor-move-right e) (if (= (editor-cursorPos e) (string-length (editor-text e))) e (make-editor (editor-text e) (+ (editor-cursorPos e) 1))))   

;; Editor -> Editor
;; Moves the cursor to the X coord
(check-expect (cursor-move-x E1 5) (make-editor ""    0 ))  
(check-expect (cursor-move-x E2 2) (make-editor "tester" 2 ))  

; (define (cursor-move-x e x) e) ;stub

;; took template from Editor  
(define (cursor-move-x e x) (if (= (editor-cursorPos e) (string-length (editor-text e))) e (make-editor (editor-text e) (+ (editor-cursorPos e) x))))  

;; Editor -> Editor
;; Removes one character from the text string
(check-expect (char-backspace E1) (make-editor ""    0 ))  
(check-expect (char-backspace E3) (make-editor "teter" 2 ))  

;; (define (char-backspace e) e) ;stub

;; took template from Editor 

(define (char-backspace e) (if (= (editor-cursorPos e) 0)   
                               e   
                               (make-editor (string-append   
                                             (substring (editor-text e) 0 (- (editor-cursorPos e) 1))  
                                             (substring (editor-text e)  (editor-cursorPos e) (string-length (editor-text e))) )  
                                            (- (editor-cursorPos e) 1 )) ))  


;; Editor -> Editor
;; Adds one character to the text string
(check-expect (char-add "a" E2) (make-editor "atester"    1 ))  
(check-expect (char-add "s" E4) (make-editor "testers" 7 ))   

;;(define (char-add key e) e) ;stub  

;; took template from Editor  

(define (char-add key e) (if (char-ignore? key) e (make-editor (string-append   
                                                                (substring (editor-text e) 0 (editor-cursorPos e))   
                                                                key   
                                                                (substring (editor-text e) (editor-cursorPos e) (string-length (editor-text e) ))  
                                                                )  
                                                               (+ (editor-cursorPos e) 1)) )) 

;; Key -> Boolean  
;; If pressed key is up, down, shift, rshift, control, alt return true    

(check-expect (char-ignore? "a") false)  
(check-expect (char-ignore? "shift") true)  
(check-expect (char-ignore? "rshift") true)  

;(define (char-ignore? "a") false) ;stub  

;; template used
;; Atomic Non Distinct : Boolean
(define (char-ignore? a) (if (or (string=? a "up") (string=? a "down") (string=? a "shift") (string=? a "rshift") (string=? a "control") (string=? a "menu")  ) true false))