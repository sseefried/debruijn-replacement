module DebruijnReplacement where

type Name = Integer -- anything ordered will do

data Expr
  = Var Name
  | App Expr Expr
  | Lam Name Expr deriving Show


lam :: (Expr -> Expr) -> Expr
lam f = Lam n body
  where body = f (Var n)
        n    = maxBV body + 1 -- circular programming. Mutual recursion between 'body' and 'n'


bot :: Name
bot = 0

-- Computes the maximum bound variable in the given expression
maxBV :: Expr -> Name
maxBV (Var _) = bot
maxBV (App f a) = maxBV f `max` maxBV a
maxBV (Lam n _) = n


{-

How do we convince ourselves that circular programming even works? By evalutating!

In the paper (http://www.cse.chalmers.se/~emax/documents/axelsson2013using.pdf)

Let's look at an example, a simple one first:

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

-}
