{-# LANGUAGE TemplateHaskell #-}
module BadIntel.Types.Agency 
( 
    Organigram
    ,Position
    ,Hierarchy (..)
    ,Agency (..)
    ,buildOrganigram
    ,getAvailableRanks 
    ,potentialAgents
    ,unassigned
    ,organigram
    ,ukAgency')
where

import Data.Tree
import Control.Lens

import BadIntel.Types.Agent

{- A rank in a hierarchy -}
type Rank = String

{- A position that might be filled in, 
 - which means a rank and maybe an agent -}
type Position = (Rank, Maybe Agent)

{- A full agency, with its hierarchy and 
agents. -}
type Organigram = Tree Position

{- A potential agency, used to build the real ones -}
data Hierarchy = Hierarchy String [Hierarchy]

data Agency = Agency { _budget :: Int
                     , _realIntel :: Int
                     , _fakeIntel :: Int
                     , _organigram :: Organigram
                     , _potentialAgents :: [Agent]
                     , _unassigned :: [Agent] }

$(makeLenses ''Agency)

{- The UK agency. Will probably be moved to some config file. -}
ukAgency :: Hierarchy
ukAgency = Hierarchy "Director" 
            [Hierarchy "Political director"
              [Hierarchy "Foreign office liaison" []
              ,Hierarchy "Treasury negociator" []
              ,Hierarchy "Chief analyst" 
                [Hierarchy "Allies strategy analyst" []
                ,Hierarchy "Sovietology analyst" []
                ,Hierarchy "Third-world analyst" []]]
            ,Hierarchy "Intelligence director"
              [Hierarchy "European director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]
              ,Hierarchy "Soviet block director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]
              ,Hierarchy "Asian director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]
              ,Hierarchy "African director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]
              ,Hierarchy "South-American director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]
              ,Hierarchy "North-American director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]
              ,Hierarchy "Middle-East director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]]
            ,Hierarchy "Operational director"
              [Hierarchy "Foreign actions director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]
              ,Hierarchy "Domestic actions director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]
              ,Hierarchy "Covert operations director"
                [Hierarchy "Operative" []
                ,Hierarchy "Operative" []
                ,Hierarchy "Operative" []]]
            ,Hierarchy "Counter-intelligence director"
                [Hierarchy "Counter-terrorism director"
                    [Hierarchy "Operative" []
                    ,Hierarchy "Operative" []
                    ,Hierarchy "Operative" []]
                ,Hierarchy "Counter-espionnage director"
                    [Hierarchy "Operative" []
                    ,Hierarchy "Operative" []
                    ,Hierarchy "Operative" []]]]

buildOrganigram :: Hierarchy -> Organigram
buildOrganigram = unfoldTree (\(Hierarchy n xs) -> ((n, Nothing), xs))

getAvailableRanks :: Organigram -> Organigram
getAvailableRanks = unfoldTree stopIfNoBoss
    where 
          stopIfNoBoss (Node (r, Just ag) xs) = ((r, Just ag), xs)
          stopIfNoBoss (Node (r, Nothing) _)  = ((r, Nothing), [])

addAgent :: Agent -> Agency -> Agency
addAgent a = over unassigned ((:) a) 

ukAgency' p = Agency 1000 0 0 (buildOrganigram ukAgency) p [] -- temporary
