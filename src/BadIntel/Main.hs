import System.Random
import System.Console.Haskeline
import Data.Char

import BadIntel.BadIntel
import BadIntel.Types.Agency
import BadIntel.Random.Names
import BadIntel.Console.Display

main :: IO ()
main = do g <- buildGame
          runInputT defaultSettings (loop g)

loop :: BadIntel -> InputT IO ()
loop g = do mapM_ outputStrLn menu
            c <- pickNumber 1 4
            (menu_functions !! (c-1)) g

buildGame :: IO BadIntel
buildGame = do names <- getNames
               return $ Game names ukAgency' ukAgency' []

pickNumber :: Int -> Int -> InputT IO Int
pickNumber min max = do input <- getInputChar "> "
                        case input of
                            Nothing -> pickNumber min max
                            Just x -> validOrLoop x
    where 
           validOrLoop x
            | isDigit x = inMargin . digitToInt $ x
            | otherwise = pickNumber min max
           inMargin x
            | x >= min && x <= max = return x
            | otherwise = pickNumber min max

menu :: [String]
menu = ["1. See the agency organigram."
       ,"2. Recruit agent."
       ,"3. Manage agents."
       ,"4. End turn."]

menu_functions :: [BadIntel -> InputT IO ()]
menu_functions = [agency_org
                 ,menu_recruitement
                 ,menu_management
                 ,end_turn]

agency_org = mapM_ outputStrLn . getAgencyLineUp . _organigram . _ukAgency
menu_recruitement = undefined
menu_management = undefined
end_turn = undefined        
