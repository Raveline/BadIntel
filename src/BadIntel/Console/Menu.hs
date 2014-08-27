module BadIntel.Console.Menu
(enterMenu
,enterMenu')
where

import System.Console.Haskeline
import Data.Char
import qualified Data.Map as Map

enterMenu :: [String] -> InputT IO Int
enterMenu c = do displayMenu c
                 let max = length c
                 pickNumber 1 max

enterMenu' :: [String] -> [a -> InputT IO ()] -> a -> InputT IO ()
enterMenu' m fs o = do c <- enterMenu m
                       case Map.lookup c (toMenuIndex fs) of
                            Nothing -> error "Menu does not contain this index."
                            Just f -> f o

displayMenu :: [String] -> InputT IO ()
displayMenu = mapM_ outputStrLn . toMenu

toMenu :: [String] -> [String]
toMenu = map (uncurry concatNums) . zip [1..]
    where concatNums n s = (intToDigit n):". " ++ s

toMenuIndex :: [a] -> Map.Map Int a
toMenuIndex = Map.fromList . zip [1..] 

pickNumber :: Int -> Int -> InputT IO Int
pickNumber min max = do input <- getInputChar "> "
                        case input of
                            Nothing -> pickNumber min max
                            Just x -> case validOrLoop x of
                                Nothing -> pickNumber min max
                                Just x' -> return x'
    where 
           validOrLoop x
            | isDigit x = inMargin . digitToInt $ x
            | otherwise = Nothing
           inMargin x
            | x >= min && x <= max = Just x
            | otherwise = Nothing

