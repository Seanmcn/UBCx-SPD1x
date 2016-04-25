;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname is-empty-string) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; String -> Boolean
;; produce true if string length is 0
(check-expect (empty-string? "") true)
(check-expect (empty-string? 0) false)
(check-expect (empty-string? "abc") false)

;define (empty-string? s) true) ;stub

(define (empty-string? s)
  (zero? (string-length s)))