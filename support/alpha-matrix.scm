(use imlib2)
(use srfi-1)

(define (build-row file #!optional (rowno 2))
  (let* ((img (image-load file))
         (width (image-width img))
         (y rowno))
    (let loop ((x 2) (data '()))
      (if (>= x width)
        (begin
          (image-destroy img)
          (reverse data))
        (let-values (((r g b a) (image-pixel/rgba img x y)))
          (loop (+ x 4) (cons a data)))))))
  
(define (build-column file #!optional (colno 2))
  (let* ((img (image-load file))
         (height (image-height img))
         (x colno))
    (let loop ((y 2) (data '()))
      (if (>= y height)
        (begin
          (image-destroy img)
          (reverse data))
        (let-values (((r g b a) (image-pixel/rgba img x y)))
          (loop (+ y 4) (cons a data)))))))
  
(define (build-matrix file)
  (let* ((img (image-load file))
         (width (image-width img))
         (height (image-height img)))
    (let hloop ((x 2) (hdata '()))
      (if (>= x width)
        (begin
          (image-destroy img)
          (reverse hdata))
        (hloop
          (+ x 4)
          (cons
            (let vloop ((y 2) (vdata '()))
              (if (>= y height)
                (reverse vdata)
                (let-values (((r g b a) (image-pixel/rgba img x y)))
                  (vloop (+ y 4) (cons a vdata)))))
            hdata))))))

(define (get-matrix color)
  (let ((upper-image (string-append "mtx-" color "-u.png"))
        (lower-image (string-append "mtx-" color "-l.png"))
        (result-image (string-append "mtx-" color "-r.png")))
    (values (build-row upper-image) (build-column lower-image) (build-matrix result-image))))
