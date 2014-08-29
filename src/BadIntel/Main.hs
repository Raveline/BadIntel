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

loop :: BadIntel -> InputT IO ()
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

menuFunctions :: [BadIntel -> InputT IO ()]
menuFunctions = [agency_org
                ,menu_recruitement
                ,menu_management
                ,end_turn]

agency_org = mapM_ outputStrLn . getAgencyLineUp . _organigram . _ukAgency
menu_recruitement :: BadIntel -> InputT IO ()
menu_recruitement g = do let pool = currentRecruitementPool g
                         c <- enterMenu . map agentLine $ pool
                         if c == 0 then return ()
                                   else displayAgent (currentRecruitementPool g !! c)
    where 
          agentLine a = _name a ++ " (" ++ showSkill (averageLevel a) ++ ")"
          displayAgent a = mapM_ outputStrLn (describe a)
                           >> recruitOrNot g a
                           >> menu_recruitement g
          recruitOrNot :: BadIntel -> Agent -> InputT IO ()
          recruitOrNot g a = yesNo "Do you want to recruit this potential agent (y/N) ?" (recruitment a g)

recruitment :: Agent -> BadIntel -> InputT IO ()
recruitment a = return . fst . runState (process (recruit a)) 

menu_management = undefined
end_turn = undefined

currentRecruitementPool :: BadIntel -> [Agent]
currentRecruitementPool = take 5 . view (ukAgency . potentialAgents)
