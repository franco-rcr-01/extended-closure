(define-module (ext-closure)
	#:use-module (ice-9 match)
)

(define-syntax make-ext-closure
  (lambda (x)
    (define gen-id
      (lambda (template-identifier . args )
	(datum->syntax
	 template-identifier
	 (string->symbol
	  (apply string-append
		 (map (lambda (x)
			(if (string? x)
			    x
			    (symbol->string (syntax->datum x))))
		      args ))))))
    (syntax-case x ()
      ((_ name prefix (pars-list ...) (assignment-list ...) expr ...)
       (with-syntax (((expr-list ...)
		      (map (lambda (x)
			     (let ((e1 (caar (syntax->datum x))))
			       (list (datum->syntax x 'define) (gen-id x #'prefix "::" e1)
				     (datum->syntax x (list 'quote e1)))))
			   #'(expr ...)))
		     ((matchers-list ...)
		      (map (lambda (x)
			     (let ((e-1 (car (syntax->datum x)))
				   (e-rest (cdr (syntax->datum x))))
			       (cons (datum->syntax x (cons (list 'quote (car e-1)) (cdr e-1)))
				     (datum->syntax x e-rest))))
			   #'(expr ...)))
		     ((runpars-list ...)
		      (map (lambda (x) (datum->syntax x (car (syntax->datum x)))) #'(assignment-list ...))
		      )
		     )
	 #'(begin
	     expr-list ...
	     (define name (lambda (pars-list ...)
			    (letrec* (assignment-list ...
						      (prefix (lambda* (cmd . pars)
								(match (cons cmd pars)
								  matchers-list ...
								  (_ (display "Command not recognized") (newline))))))
			      (lambda (cmd . pars)
				(apply prefix (cons cmd pars))))))))))))

(export-syntax make-ext-closure)

