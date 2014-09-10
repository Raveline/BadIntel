{-# LANGUAGE TemplateHaskell, ImpredicativeTypes #-}
module BadIntel.Types.Agency 
( 
    Organigram
    ,Position
    ,Hierarchy (..)
    ,PositionOutput(..)
    ,Rank(..)
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

{- The kind of output that can be expected from an agent holding a given
position -}
data PositionOutput =
    Raw                 -- Raw intelligence, a piece of information
  | Intel               -- Analyzed intelligence, a piece of the big picture
  | Politics            -- Support by politicians
  | Budget              -- Financial support
  | OffensiveMissions   -- Ability to strike abroad
  | DefensiveMissions   -- Ability to protect the motherland
  | Infiltration        -- Ability to recruit and manage mole
  | Countering          -- Ability to detect moles and bad intelligence

{- A rank in a hierarchy -}
data Rank = Rank 
    { _rankName :: String
    , _output :: PositionOutput
    , _bonus :: Maybe (Agent -> Skill) -- Eventual bonus to subordinates
    }

instance Show Rank where
    show = _rankName

instance Eq Rank where
    a == b = (_rankName a) == (_rankName b)

{- A position that might be filled in, 
which means a rank and maybe an agent -}
type Position = (Rank, Maybe Agent)

{- A full agency, with its hierarchy and 
agents. -}
type Organigram = Tree Position

{- A potential agency, used to build the real ones -}
data Hierarchy = Hierarchy Rank [Hierarchy]

data Agency = Agency { _budget :: Int
                     , _rawRealIntel :: Int
                     , _rawFakeIntel :: Int
                     , _realIntel :: Int
                     , _fakeIntel :: Int
                     , _organigram :: Organigram
                     , _potentialAgents :: [Agent]
                     , _unassigned :: [Agent] }

$(makeLenses ''Agency)

{- The UK agency. Will probably be moved to some config file. -}
ukAgency :: Hierarchy
ukAgency = Hierarchy (Rank "Director" Politics Nothing)
            [Hierarchy (Rank "Political director" Politics Nothing)
                [Hierarchy (Rank "Foreign office liaison" Politics Nothing) []
                ,Hierarchy (Rank "Treasury negociator" Budget Nothing) []
                ,Hierarchy (Rank "Chief analyst" Intel (Just $ view analyzing)) 
                    [Hierarchy (Rank "Allies strategy analyst" Intel Nothing) []
                    ,Hierarchy (Rank "Sovietology analyst" Intel Nothing) []
                    ,Hierarchy (Rank "Third-world analyst" Intel Nothing) []]]
            ,Hierarchy (Rank "Intelligence director" Raw (Just $ view collecting))
              [Hierarchy (Rank "European director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "Soviet block director" Raw (Just$ view  collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "Asian director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "African director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "South-American director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "North-American director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "Middle-East director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]] 
            ,Hierarchy (Rank "Operational director" Countering (Just $ view loyalty))
              [Hierarchy (Rank "Foreign actions director" OffensiveMissions (Just $ view hiding))
                [Hierarchy (Rank "Operative" OffensiveMissions Nothing) []
                ,Hierarchy (Rank "Operative" OffensiveMissions Nothing) []
                ,Hierarchy (Rank "Operative" OffensiveMissions Nothing) []]
              ,Hierarchy (Rank "Domestic actions director" DefensiveMissions (Just $ view fighting))
                [Hierarchy (Rank "Operative" DefensiveMissions Nothing) []
                ,Hierarchy (Rank "Operative" DefensiveMissions Nothing) []
                ,Hierarchy (Rank "Operative" DefensiveMissions Nothing) []]
              ,Hierarchy (Rank "Covert operations director" Infiltration (Just $ view convincing))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]] 
            ,Hierarchy (Rank "Counter-intelligence director" Countering (Just $ view loyalty))
              [Hierarchy (Rank "Counter-terrorism director" Countering (Just $ view fighting))
                    [Hierarchy (Rank "Operative" Countering Nothing) []
                    ,Hierarchy (Rank "Operative" Countering Nothing) []
                    ,Hierarchy (Rank "Operative" Countering Nothing) []]
              ,Hierarchy (Rank "Counter-espionnage director" Countering (Just $ view analyzing))
                    [Hierarchy (Rank "Operative" Countering Nothing) []
                    ,Hierarchy (Rank "Operative" Countering Nothing) []
                    ,Hierarchy (Rank "Operative" Countering Nothing) []]]] 

buildOrganigram :: Hierarchy -> Organigram
buildOrganigram = unfoldTree (\(Hierarchy n xs) -> ((n, Nothing), xs))

getAvailableRanks :: Organigram -> Organigram
getAvailableRanks = unfoldTree stopIfNoBoss
    where 
          stopIfNoBoss (Node (r, Just ag) xs) = ((r, Just ag), xs)
          stopIfNoBoss (Node (r, Nothing) _)  = ((r, Nothing), [])

addAgent :: Agent -> Agency -> Agency
addAgent a = over unassigned ((:) a) 

ukAgency' p = Agency 1000 0 0 0 0 (buildOrganigram ukAgency) p [] -- temporary

