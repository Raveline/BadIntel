{-# LANGUAGE TemplateHaskell #-}
module BadIntel.BadIntel
( BadIntel (..)
, ukAgency
, ruAgency )
where

import Data.List
import Control.Lens

import BadIntel.Types.Agent
import BadIntel.Types.Agency
import BadIntel.Random.Names

data BadIntel = Game { _ukAgency :: Agency
                     , _ruAgency :: Agency
                     }

$(makeLenses ''BadIntel)

