module BadIntel.Game.Update
(updateAgency)
where

import Control.Lens

import BadIntel.Types.Agent
import BadIntel.Types.Agency

updateAgency :: Agency -> Agency
updateAgency a = a & organigram.traversed %~ updateAgent a

updateAgent :: Agency -> Position -> Position
updateAgent agency agent = undefined
