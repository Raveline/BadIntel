module BadIntel.Console.Menu
(enterMenu
,enterMenu'
,yesNo)
where

import Control.Monad
import Data.Char
import System.Console.Haskeline
import qualified Data.Map as Map

enterMenu :: [String] -> InputT IO Int
enterMenu c = do displayMenu c
                 input <- getInputChar "> "
                 let max = length c
                 let choice = join . fmap (pickNumber 0 max) $ input
                 case choice of
                    Just x -> return x
                    Nothing -> enterMenu c

enterMenu' :: [String] -> [a -> InputT IO a] -> a -> InputT IO a
enterMenu' m fs o = do c <- enterMenu m
                       if c == 0 then return o
                                 else case Map.lookup c (toMenuIndex fs) of
                                    Nothing -> error "Menu does not contain this index."
                                    Just f -> f o
                                              >>= enterMenu' m fs

displayMenu :: [String] -> InputT IO ()
displayMenu = mapM_ outputStrLn . toMenu

toMenu :: [String] -> [String]
toMenu = zipWith concatNums [1..]
    where concatNums n s = intToDigit n:". " ++ s

toMenuIndex :: [a] -> Map.Map Int a
toMenuIndex = Map.fromList . zip [1..] 

pickNumber :: Int -> Int -> Char -> Maybe Int
pickNumber min max c = do c' <- tryToInt c
                          inMargin c'
    where
          tryToInt x
            | isDigit x = Just . digitToInt $ x
            | otherwise = Nothing
          inMargin x
            | x >= min && x <= max = Just x
            | otherwise = Nothing

yesNo :: String -> (a -> InputT IO a) -> a -> InputT IO a
yesNo s f a = do outputStrLn s
                 c <- getInputChar "> "
                 case c of
                    Just x -> if x == 'y' then f a
                                          else return a
                    Nothing -> yesNo s f a
