module BadIntel.Config.Config
( MonadConfig
, Config (..)
, pickName )
where

import Control.Monad.State

import BadIntel.Types.Common
import BadIntel.Random.Names

type MonadConfig a = StateT Config a

data Config = Config { _ukNameCollection :: NameCollection
                     , _ruNameCollection :: NameCollection }

rebuildConfig :: Country -> NameCollection -> Config -> Config
rebuildConfig Uk col conf     = conf { _ukNameCollection = col }
rebuildConfig Russia col conf = conf { _ruNameCollection = col }

countryToNameCollection :: Country -> Config -> NameCollection
countryToNameCollection Uk = _ukNameCollection
countryToNameCollection Russia = _ruNameCollection

pickName :: (Monad m) => Country -> Gender -> MonadConfig m String
pickName c g = do conf <- get
                  let collection = countryToNameCollection c conf
                  let list = listFromGender g collection
                  let list' = tail list
                  let collection' = rebuildCollection g list' collection
                  put $ rebuildConfig c collection' conf
                  return $ head list
