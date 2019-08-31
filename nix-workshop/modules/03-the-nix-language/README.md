# The Nix Language

## 📖 Overview

The Nix expression language is a pure, lazy, functional language.

- Purity means that operations in the language don't have side-effects (for instance, there is no variable assignment). The only side effects are deliberate and controlled, and aimed at its main function of building software packages.
- Laziness means that arguments to functions are evaluated only when they are needed. 
- Functional means that functions are “normal” values that can be passed around and manipulated in interesting ways.

The language is not a full-featured, general purpose language. Its main job is to describe packages, compositions of packages, and the variability within packages.

Depending on how much time you have and how deep you want to dive, we recommend you follow these three courses of action:

1. [Learn Nix in Y minutes-internal ref], which can be done from top to bottom in 15 minutes.
2. [Nix by Example-internal] adds content and nuance. After doing the above, it can take 30 minutes or more.
3. [A tour of Nix-internal ref] is a longer (1h+) interactive dive into the Nix programming language, covering a good number of built-in and library functions.

https://nixos.wiki/wiki/Nix_Expression_Language

## Learn Nix in Y minutes

A good introduction to the Nix Expression Language is in [Learn Nix in Y minutes]. We've copied it here and updated it for this workshop, as the last update in the site was for a Nix version previous to 2.0, and the latest 

We recommend you follow these examples using [`nix repl`].

```
with builtins; [

  #  Comments
  #=========================================

  # Inline comments look like this.

  /* Multi-line comments
     look like this. */


  #  Booleans
  #=========================================

  (true && false)               # And
  #=> false

  (true || false)               # Or
  #=> true

  (if 3 < 4 then "a" else "b")  # Conditional
  #=> "a"


  #  Integers and Floats
  #=========================================

  # There are two numeric types: integers and floats

  1 0 42 (-3)       # Some integers

  123.43 .27e13     # A couple of floats

  # Operations will preserve numeric type

  (4 + 6 + 12 - 2)  # Addition
  #=> 20
  (4 - 2.5)
  #=> 1.5

  (7 / 2)           # Division
  #=> 3
  (7 / 2.0)
  #=> 3.5


  #  Strings
  #=========================================

  "Strings literals are in double quotes."

  "
    String literals can span
    multiple lines.
  "

  ''
    This is called an "indented string" literal.
    It intelligently strips leading whitespace.
  ''

  ''
    a
      b
  ''
  #=> "a\n  b"

  ("ab" + "cd")   # String concatenation
  #=> "abcd"

  # Antiquotation lets you embed values into strings.
  ("Your home directory is ${getEnv "HOME"}")
  #=> "Your home directory is /home/alice"


  #  Paths
  #=========================================

  # Nix has a primitive data type for paths.
  /tmp/tutorials/learn.nix

  # A relative path is resolved to an absolute path at parse
  # time, relative to the file in which it occurs.
  tutorials/learn.nix
  #=> /the-base-path/tutorials/learn.nix

  # A path must contain at least one slash, so a relative
  # path for a file in the same directory needs a ./ prefix,
  ./learn.nix
  #=> /the-base-path/learn.nix

  # The / operator must be surrounded by whitespace if
  # you want it to signify division.

  7/2        # This is a path literal
  (7 / 2)    # This is integer division


  #  Imports
  #=========================================

  # A nix file contains a single top-level expression with no free
  # variables. An import expression evaluates to the value of the
  # file that it imports.
  (import /tmp/foo.nix)

  # Imports can also be specified by strings.
  (import "/tmp/foo.nix")

  # Import paths must be absolute. Path literals
  # are automatically resolved, so this is fine.
  (import ./foo.nix)

  # But this does not happen with strings.
  (import "./foo.nix")
  #=> error: string ‘foo.nix’ doesn't represent an absolute path


  #  Let
  #=========================================

  # `let` blocks allow us to bind values to variables.
  (let x = "a"; in
    x + x + x)
  #=> "aaa"

  # Bindings can refer to each other, and their order does not matter.
  (let y = x + "b";
       x = "a"; in
    y + "c")
  #=> "abc"

  # Inner bindings shadow outer bindings.
  (let a = 1; in
    let a = 2; in
      a)
  #=> 2


  #  Functions
  #=========================================

  (n: n + 1)      # Function that adds 1

  ((n: n + 1) 5)  # That same function, applied to 5
  #=> 6

  # There is no syntax for named functions, but they
  # can be bound by `let` blocks like any other value.
  (let succ = (n: n + 1); in succ 5)
  #=> 6

  # A function has exactly one argument.
  # Multiple arguments can be achieved with currying.
  ((x: y: x + "-" + y) "a" "b")
  #=> "a-b"

  # We can also have named function arguments,
  # which we'll get to later after we introduce sets.


  #  Lists
  #=========================================

  # Lists are denoted by square brackets.

  (length [1 2 3 "x"])
  #=> 4

  ([1 2 3] ++ [4 5])
  #=> [1 2 3 4 5]

  (concatLists [[1 2] [3 4] [5]])
  #=> [1 2 3 4 5]

  (head [1 2 3])
  #=> 1
  (tail [1 2 3])
  #=> [2 3]

  (elemAt ["a" "b" "c" "d"] 2)
  #=> "c"

  (elem 2 [1 2 3])
  #=> true
  (elem 5 [1 2 3])
  #=> false

  (filter (n: n < 3) [1 2 3 4])
  #=> [ 1 2 ]


  #  Sets
  #=========================================

  # A "set" is an unordered mapping with string keys.
  { foo = [1 2]; bar = "x"; }

  # The . operator pulls a value out of a set.
  { a = 1; b = 2; }.a
  #=> 1

  # The ? operator tests whether a key is present in a set.
  ({ a = 1; b = 2; } ? a)
  #=> true
  ({ a = 1; b = 2; } ? c)
  #=> false

  # The // operator merges two sets.
  ({ a = 1; } // { b = 2; })
  #=> { a = 1; b = 2; }

  # Values on the right override values on the left.
  ({ a = 1; b = 2; } // { a = 3; c = 4; })
  #=> { a = 3; b = 2; c = 4; }

  # The rec keyword denotes a "recursive set",
  # in which attributes can refer to each other.
  (let a = 1; in     { a = 2; b = a; }.b)
  #=> 1
  (let a = 1; in rec { a = 2; b = a; }.b)
  #=> 2

  # Nested sets can be defined in a piecewise fashion.
  {
    a.b   = 1;
    a.c.d = 2;
    a.c.e = 3;
  }.a.c
  #=> { d = 2; e = 3; }

  # Sets are immutable, so you can't redefine an attribute:
  {
    a = { b = 1; };
    a.b = 2;
  }
  #=> attribute 'a.b' at (string):3:5 already defined at (string):2:11

  # However, an attribute's set members can also be defined piecewise
  # way even if the attribute itself has been directly assigned.
  {
    a = { b = 1; };
    a.c = 2;
  }
  #=> { a = { b = 1; c = 2; }; }


  #  With
  #=========================================

  # The body of a `with` block is evaluated with
  # a set's mappings bound to variables.
  (with { a = 1; b = 2; };
    a + b)
  # => 3

  # Inner bindings shadow outer bindings.
  (with { a = 1; b = 2; };
    (with { a = 5; };
      a + b))
  #=> 7

  # This first line of tutorial starts with "with builtins;" # because builtins is a set the contains all of the built-in # functions (length, head, tail, filter, etc.). This saves # us from having to write, for example, "builtins.length"
  # instead of just "length".


  #  Set patterns
  #=========================================

  # Sets are useful when we need to pass multiple values
  # to a function.
  (args: args.x + "-" + args.y) { x = "a"; y = "b"; }
  #=> "a-b"

  # This can be written more clearly using set patterns.
  ({x, y}: x + "-" + y) { x = "a"; y = "b"; }
  #=> "a-b"

  # By default, the pattern fails on sets containing extra keys.
  ({x, y}: x + "-" + y) { x = "a"; y = "b"; z = "c"; }
  #=> error: anonymous function called with unexpected argument ‘z’

  # Adding ", ..." allows ignoring extra keys.
  ({x, y, ...}: x + "-" + y) { x = "a"; y = "b"; z = "c"; }
  #=> "a-b"


  #  Errors
  #=========================================

  # `throw` causes evaluation to abort with an error message.
  (2 + (throw "foo"))
  #=> error: foo

  # `tryEval` catches thrown errors.
  (tryEval 42)
  #=> { success = true; value = 42; }
  (tryEval (2 + (throw "foo")))
  #=> { success = false; value = false; }

  # `abort` is like throw, but it's fatal; it cannot be caught.
  (tryEval (abort "foo"))
  #=> error: evaluation aborted with the following error message: ‘foo’

  # `assert` evaluates to the given value if true;
  # otherwise it throws a catchable exception.
  (assert 1 < 2; 42)
  #=> 42
  (assert 1 > 2; 42)
  #=> error: assertion failed at (string):1:1
  (tryEval (assert 1 > 2; 42))
  #=> { success = false; value = false; }


  #  Impurity
  #=========================================

  # Because repeatability of builds is critical to the Nix package
  # manager, in which, functional purity is emphasized in the Nix
  # language. But there are a few impurities.

  # You can refer to environment variables.
  (getEnv "HOME")
  #=> "/home/alice"

  # The trace function is used for debugging. It prints the first
  # argument to stderr and evaluates to the second argument.
  (trace 1 2)
  #=> trace: 1
  #=> 2

  # You can write files into the Nix store. Although impure, this is
  # fairly safe because the file name is derived from the hash of
  # its contents. You can read files from anywhere. In this example,
  # we write a file into the store, and then read it back out.
  (let filename = toFile "foo.txt" "hello!"; in
    [filename (builtins.readFile filename)])
  #=> [ "/nix/store/ayh05aay2anx135prqp0cy34h891247x-foo.txt" "hello!" ]

  # We can also download files into the Nix store.
  (fetchurl "https://example.com/package-1.2.3.tgz")
  #=> "/nix/store/2drvlh8r57f19s9il42zg89rdr33m2rm-package-1.2.3.tgz"

]
```

## Nix by example

https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55

## A tour of Nix

[A tour of Nix] rocks. If you have an hour or more, it will give you the deep
dive you need to become conversant with the Nix language. Take your time, and
consult the [Nix Expression Language section of the Nix manual] as you go along.

This tutorial is on Nix 1.9, but it's not outdated at all!

## 🗹 Recap


Analysis of `dymaxion:configuration.nix` from this point of view


## Acknowledgements

[Learn Nix in Y minutes] was originally authored by Chris Martin.

## 📚 Additional material

* The ur-reference is the [Nix expression Language section of the Nix manual]
* For anyone struggling with some of the concepts there is a good explanation of the [Nix language in the Nix Wiki].

## ⏭️ What's next

We move on to building stuff with Nix. Yay.


<!-- in-line links -->
[Nix Manual]: https://nixos.org/nix/manual/ 
[Nix Expression Language section of the Nix manual]: https://nixos.org/nix/manual/#ch-expression-language
[Nix language in the Nix Wiki]: https://nixos.wiki/wiki/Nix_Expression_Language
[Learn Nix in Y minutes]: https://learnxinyminutes.com/docs/nix/
[A tour of Nix]: https://nixcloud.io/tour/
[`nix repl`]: https://nixos.org/nix/manual/#ssec-relnotes-2.0