module BadIntel.Random.AgentsPool
( buildPool )
where

import Control.Monad
import Control.Monad.Random
import System.Random.Shuffle

import BadIntel.Types.Agent
import BadIntel.Types.Common
import BadIntel.Random.Names
import BadIntel.Config.Config

defaultSalary = 100

buildAgent :: (MonadRandom m) => Country -> MonadConfig m Agent
buildAgent c = flipGender >>= pickName c >>= buildAgent' defaultSalary
    where
        buildAgent' s n = do col <- castSkill
                             a   <- castSkill
                             f   <- castSkill
                             con <- castSkill
                             h   <- castSkill
                             l   <- castSkill
                             return $ Agent n col a f con h l s

castSkill :: (MonadRandom m) => m Int
castSkill = getRandomR (4,15)

flip' :: (MonadRandom m) => m Bool
flip' = getRandomR (True, False)

flipGender :: (MonadRandom m) => m Gender
flipGender = do f <- flip' 
                return (if f then Female
                        else Male)

buildPool :: (MonadRandom m) => Int -> Country -> MonadConfig m [Agent]
buildPool n c = replicateM n (buildAgent c)
