module BadIntel.Console.Display
( getAgencyLineUp )
where

import Data.Tree

import BadIntel.Types.Agency

{- Display an agency ranks by ranks, with tabulations to show 
 - the hierarchy at play. -}
getAgencyLineUp :: Organigram -> [String]
getAgencyLineUp = showPosition 0
    where 
          showPosition :: Int -> Organigram -> [String]
          showPosition tabs (Node p xs) = showOne tabs p : concatMap (showPosition (succ tabs)) xs
          showOne :: Int -> Position -> String
          showOne tabs (r, a) = putTabs tabs ++ r ++ " : " ++ posToString a
          posToString = maybe "VACANT" show
          putTabs = concat . flip replicate "\t"
