(add-to-load-path "./")
(use-modules
 (ext-closure)
 (ice-9 match)
 )


(define (AccumulatorGenerator add-neutral mul-neutral)
  (let ((add-accumulator add-neutral)
	(mul-accumulator mul-neutral))
    (lambda (cmd . pars)
      (match (cons cmd pars)
	(('add v) (set! add-accumulator (+ add-accumulator v)) add-accumulator)
	(('mul v) (set! mul-accumulator (* mul-accumulator v)) mul-accumulator)
	(('reset-add) (set! add-accumulator add-neutral))
	(('reset-mul) (set! mul-accumulator mul-neutral))
	))))


