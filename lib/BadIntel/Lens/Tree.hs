{- This module exports a method to search for a given value in a tree
 - and return a lens focusing on this value. It is then easy to modify
 - this value optimally using the Lens library. -}
module BadIntel.Lens.Tree
( findLens )
where

import Control.Lens
import Control.Monad
import Data.Tree
import Data.Tree.Lens
import Data.Maybe
import Data.List (findIndex)

findLens a t = readPath . findPath a $ t

{- Find the indices of each node till a given value
 - is found. If no value is found, there should be a
 - simple [Nothing]. If the value is in the first
 - visited node, result will be [] -}
findPath :: (Eq a) => a -> Tree a -> Maybe [Int]
findPath s (Node n xs)
    | s == n = Just []
    | otherwise = do x <- findIndex(tcontains s) xs
                     ys <- xs^?ix x >>= findPath s
                     return (x:ys)
    where
        tcontains s (Node n xs)
            | s == n = True
            | otherwise = any (tcontains s) xs

readPath Nothing = error "Value does not exist."
readPath (Just []) = root
readPath (Just xs) = toBranchIxes . root
    where toBranchIxes :: (Tree a -> Identity (Tree a)) -> Tree a -> Identity (Tree a)
          toBranchIxes = compose $ map ((branches .) . ix) xs
          
compose = foldl (flip (.)) id

