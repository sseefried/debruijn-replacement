# Functional Pearl

This module presents the implementation of the functional pearl Using Circular Programs for Higher-Order Syntax described in this [paper](http://www.cse.chalmers.se/~emax/documents/axelsson2013using.pdf).

## Example

```
[lam (\x -> x)] should evaluate to [Lam 1 (Var 1)]

  lam (\x -> x)
= Lam n body
    where body = (\x -> x) (Var n)
             n = maxBV body + 1
  |-Focus on body = (\x -> x) Var n-
  | body = (\x -> x) (Var n)
  |      = Var n
  |-Focus on [n = maxBV body + 1]
  | n = maxBV body + 1
  |   = maxBV (Var n) + 1 -- the fact that maxBV ignores "n" here in pattern is why it works
  |   = bot + 1
  |   = 0 + 1
  |   = 1
= Lam 1 (Var 1) -- because n = 1

[lam (\x -> lam (\y -> x))] should evaluate to [Lam 2 (Lam 1 (Var 2))]

   lam (\x -> (lam (\y -> x)))
=  Lam n body
     where body = f (Var n)
             n  = maxBV body + 1
  |-Focus on [body = (\x -> (lam (y -> x))) (Var n)]
  | body = (\x -> (lam (\y -> x))) (Var n)
  |      = lam (\y -> Var n)
  |      = ... from above
  |      = Lam 1 (Var n)
  |-Focus on [n = maxBV body + 1]
  | n = maxBV body + 1
  |   = maxBV (Lam 1 (Var n)) + 1
  |   = 1 + 1
  |   = 2

= Lam 2 (Lam 1 (Var 2)) -- because n = 2

```



