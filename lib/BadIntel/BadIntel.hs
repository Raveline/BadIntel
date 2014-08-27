module BadIntel.BadIntel
( BadIntel (..)
, NameCollection (..)
, currentRecruitementPool)
where

import BadIntel.Types.Agent
import BadIntel.Types.Agency
import BadIntel.Random.Names

data BadIntel = Game { _ukAgency :: Agency
                     , _ruAgency :: Agency
                     , potentialAgents :: [Agent]
                     }

currentRecruitementPool :: BadIntel -> [Agent]
currentRecruitementPool = take 5 . potentialAgents
