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
    ,buildAgency
    ,organigram)
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
    deriving (Eq, Show)

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
    deriving (Eq, Show)

data Agency = Agency { _budget :: Int
                     , _rawRealIntel :: Int
                     , _rawFakeIntel :: Int
                     , _realIntel :: Int
                     , _fakeIntel :: Int
                     , _organigram :: Organigram
                     , _potentialAgents :: [Agent]
                     , _unassigned :: [Agent] }

$(makeLenses ''Agency)


buildOrganigram :: Hierarchy -> Organigram
buildOrganigram = unfoldTree (\(Hierarchy n xs) -> ((n, Nothing), xs))

getAvailableRanks :: Organigram -> Organigram
getAvailableRanks = unfoldTree stopIfNoBoss
    where 
          stopIfNoBoss (Node (r, Just ag) xs) = ((r, Just ag), xs)
          stopIfNoBoss (Node (r, Nothing) _)  = ((r, Nothing), [])

addAgent :: Agent -> Agency -> Agency
addAgent a = over unassigned ((:) a) 

buildAgency :: Hierarchy -> [Agent] -> Agency
buildAgency h p = Agency 1000 0 0 0 0 (buildOrganigram h) p []
