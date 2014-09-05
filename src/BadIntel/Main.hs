import Data.Tree
import Control.Lens hiding (assign)
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
       ,"Manage unassigned agents."
       ,"Manage assigned agents."
       ,"End turn."]

menuFunctions :: [BadIntel -> InputT IO BadIntel]
menuFunctions = [agency_org
                ,menu_recruitement
                ,menu_management_un
                ,menu_management_as
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
          displayAgent :: Agent -> InputT IO BadIntel
          displayAgent a = mapM_ outputStrLn (describe a)
                           >> recruitOrNot g a
                           >>= menu_recruitement
          recruitOrNot :: BadIntel -> Agent -> InputT IO BadIntel
          recruitOrNot g a = yesNo "Do you want to recruit this potential agent (y/N) ?" (recruitment a) g

recruitment :: Agent -> BadIntel -> InputT IO BadIntel
recruitment a = return . snd . runState (process (recruit a)) 

menu_management_as :: BadIntel -> InputT IO BadIntel
menu_management_as = undefined

menu_management_un :: BadIntel -> InputT IO BadIntel
menu_management_un g = do let allAgents = g^.(ukAgency.unassigned)
                          c <- enterMenu . map agentLine $ allAgents
                          if c == 0 then return g
                                    else manage_one (allAgents !! (c-1)) g
end_turn = undefined

manage_one :: Agent -> BadIntel -> InputT IO BadIntel
manage_one a g = enterMenu' manage_one_choices [set_salary a, assign_to a] g
manage_one_choices = ["Set salary"
                     ,"Assign to a post"]
manage_one_func = [set_salary
                  ,assign_to]
set_salary a g = undefined

assign_to :: Agent -> BadIntel -> InputT IO BadIntel
assign_to a g = do let available = getAvailableRanks (_organigram . _ukAgency $ g)
                   c <- enterMenu (getAgencyLineUp available)
                   let rank = fst $ (flatten available) !! (c-1)
                   return $ snd . runState (process (assign rank a)) $ g

currentRecruitementPool :: BadIntel -> [Agent]
currentRecruitementPool = take 5 . view (ukAgency . potentialAgents)

agentLine a = _name a ++ " (" ++ showSkill (averageLevel a) ++ ")"
