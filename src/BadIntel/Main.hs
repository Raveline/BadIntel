import Control.Lens
import Control.Monad.State
import System.Random
import System.Console.Haskeline
import Data.Char

import BadIntel.BadIntel
import BadIntel.Game.Mechanism
import BadIntel.Config.Config
import BadIntel.Types.Common
import BadIntel.Types.Agent
import BadIntel.Types.Agency
import BadIntel.Random.AgentsPool
import BadIntel.Random.Names
import BadIntel.Console.Display
import BadIntel.Console.Menu

main :: IO ()
main = do c <- buildConfig
          g <- buildGame c
          runInputT defaultSettings (loop g)
          return ()

loop :: BadIntel -> InputT IO BadIntel
loop = enterMenu' menu menuFunctions

buildConfig :: IO Config
buildConfig = do nUk <- getNames Uk
                 nRu <- getNames Russia
                 return $ Config nUk nRu

buildGame :: Config -> IO BadIntel
buildGame conf = do poolState <- runStateT (buildPool 20 Uk) $ conf
                    let pool = fst poolState
                    return $ Game (ukAgency' pool) (ukAgency' pool)

menu :: [String]
menu = ["See the agency organigram."
       ,"Recruit agent."
       ,"Manage agents."
       ,"End turn."]

menuFunctions :: [BadIntel -> InputT IO BadIntel]
menuFunctions = [agency_org
                ,menu_recruitement
                ,menu_management
                ,end_turn]

agency_org :: BadIntel -> InputT IO BadIntel
agency_org g = do mapM_ outputStrLn . getAgencyLineUp $ (g^.(ukAgency . organigram))
                  return g

menu_recruitement :: BadIntel -> InputT IO BadIntel
menu_recruitement g = do let pool = currentRecruitementPool g
                         c <- enterMenu . map agentLine $ pool
                         if c == 0 then return g
                                   else displayAgent (currentRecruitementPool g !! (c-1))
    where 
          agentLine a = _name a ++ " (" ++ showSkill (averageLevel a) ++ ")"
          displayAgent :: Agent -> InputT IO BadIntel
          displayAgent a = mapM_ outputStrLn (describe a)
                           >> recruitOrNot g a
                           >>= menu_recruitement
          recruitOrNot :: BadIntel -> Agent -> InputT IO BadIntel
          recruitOrNot g a = yesNo "Do you want to recruit this potential agent (y/N) ?" (recruitment a) g

recruitment :: Agent -> BadIntel -> InputT IO BadIntel
recruitment a = return . snd . runState (process (recruit a)) 

menu_management = undefined
end_turn = undefined

currentRecruitementPool :: BadIntel -> [Agent]
currentRecruitementPool = take 5 . view (ukAgency . potentialAgents)
