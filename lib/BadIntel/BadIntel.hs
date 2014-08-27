module BadIntel.BadIntel
( BadIntel (..)
, NameCollection (..))
where

import BadIntel.Types.Agent
import BadIntel.Types.Agency
import BadIntel.Random.Names

data BadIntel = Game { _nameCollection :: NameCollection
                     , _ukAgency :: Agency
                     , _ruAgency :: Agency
                     , potentialAgents :: [Agent]
                     }

