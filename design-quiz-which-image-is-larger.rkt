;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname design-quiz-which-image-is-larger) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
;; Image, Image -> Boolean
;; Produce true if first image is larger than the second image.
(define IMAGE1 (rectangle 10 15 "solid" "green"))
(define IMAGE2 (rectangle 15 20 "solid" "yellow"))

(check-expect (is-larger? IMAGE1 IMAGE2) false)
(check-expect (is-larger? IMAGE2 IMAGE1) true)
(check-expect (is-larger? IMAGE1 IMAGE1) false)

;(define (is-larger? image-one image-two) true) ;stub

(define (is-larger? image-one image-two)
  (> (* (image-height image-one) (image-width image-one)) (* (image-height image-two) (image-width image-two))))