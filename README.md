# extended-closure

## A Guile macro that generates a closure accepting commands and parameters and using the match operator to choose the code to be executed.

- Example: consider the following closure

```
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
```

- some possible uses

```
(define acc1 (AccumulatorGenerator 0 1))
(define acc2 (AccumulatorGenerator 0 1))

(acc1 'add 100) => 100
(acc1 'add 100) => 200
(acc1 'add 10) => 210
(acc2 'add 7) => 7
(acc2 'add 7) => 14

(acc1 'mul 3) => 3
(acc1 'mul 3) => 9
(acc1 'mul 3) => 27
(acc1 'mul 3) => 81
(acc1 'mul 3) => 243
```

### A closure is something like an implicit Object Orientation for the programming languages that support it. But, in this simple implementation some aspects are not managed.

- the similarity with class methods: the commands ('add or 'mul or 'reset-xxx) are similar to O.O. methods. But, with this implementation, from a method it is not possible to call another method (ie: from the 'add implementation it is not possible to call the 'mul code)
- the similarity with instance variables: the add-accumulator and mul-accumulator correspond to the instance variables of the accumulator object. Each one (acc1, acc2, ...) has different storage area for these variables.
- the similarity with _class variables_. There are not class variables. A possible implementation could be done using the guile boxes but in this release has not been considered.
- the guile code completion support: the names of the commands are symbols quoted, so they are'nt managed by the code completion mechanism of guile. For a complex closure (with many commands) this could be a problem, in opposite to the GOOPS environment that is managed by the guile completion code.

## For these reasons, I, who like closures more than GOOPS, decided to create a macro that would solve the above problems.

### Using the macro _make-ext-closure_ you can generate code similar to the following.

#### Generator: funname prefix (par1 par2) ((a par1)(b par2)) ((add n)(+ n a b))((mul n)(\* n (prefix prefix::add (+ a b)))))
