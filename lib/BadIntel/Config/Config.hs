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
                  collection <- return $ countryToNameCollection c conf
                  list <- return $ listFromGender g collection
                  list' <- return $ tail list
                  collection' <- return $ rebuildCollection g list' collection
                  put $ rebuildConfig c collection' conf
                  return $ head list
