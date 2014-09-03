{- This module exports a method to search for a given value in a tree
 - and return a lens focusing on this value. It is then easy to modify
 - this value optimally using the Lens library. -}
module BadIntel.Lens.Tree
( findLens )
where

import Control.Lens
import Data.Tree
import Data.Tree.Lens
import Data.Maybe
import Data.List (findIndex)

-- findLens :: (Eq a) => a -> Tree a -> ((Tree a -> Identity (Tree a)) -> Tree a -> Identity (Tree a))
findLens a t = readPath . findPath a $ t

{- Find the indices of each node till a given value
 - is found. If no value is found, there should be a
 - simple [Nothing]. If the value is in the first
 - visited node, result will be [] -}
findPath :: (Eq a) => a -> Tree a -> [Maybe Int]
findPath s (Node n xs)
    | s == n = []
    | otherwise = case findIndex (tcontains s) xs of
        Nothing -> [Nothing]
        Just x -> (Just x):(nextPath xs x)
    where
        tcontains s (Node n xs)
            | s == n = True
            | otherwise = or . map (tcontains s) $ xs
        nextPath xs' x' = case xs'^?(ix x') of
                            Nothing -> [Nothing]
                            Just n -> findPath s n

-- readPath :: [Maybe Int] -> ((Tree a -> Identity (Tree a)) -> Tree a -> Identity (Tree a))
readPath [] = root
readPath [Nothing] = error "Value does not exist."
readPath xs = toBranchIxes . root
    where toBranchIxes :: (Tree a -> Identity (Tree a)) -> Tree a -> Identity (Tree a)
          toBranchIxes = compose $ map ((branches .) . ix) . catMaybes $ xs
          
-- compose :: [a -> a] -> (a -> a)
compose fs = foldl (flip (.)) id fs 
