(use imlib2)

(define (copy-image infile outfile)
  (let* ((src (image-load infile))
         (width (image-width src))
         (height (image-height src))
         (dest (image-create width height)))
    (let hloop ((x 0))
      (when (< x width)
        (let vloop ((y 0))
          (when (< y height)
            (let-values (((r g b a) (image-pixel/rgba src x y)))
              (image-draw-pixel dest (color/rgba r g b a) x y))
            (vloop (+ y 1))))
        (hloop (+ x 1))))
    (image-save dest outfile))) 