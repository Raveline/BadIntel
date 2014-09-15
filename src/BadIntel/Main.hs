import Data.Tree
import Control.Lens hiding (assign)
import Control.Monad.State
import System.Random
import System.Console.Haskeline
import Data.Char

import BadIntel.BadIntel
import BadIntel.Game.Mechanism
import BadIntel.Config.Config
import BadIntel.Config.AgencyParser
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
buildGame conf = do pool <- evalStateT (buildPool 20 Uk) conf
                    agency <- readFile "ukAgency.bic"
                    ukAgency <- return $ getOrganigram agency
                    let ukAgency' = buildAgency ukAgency pool
                    return $ Game ukAgency' ukAgency'

menu :: [String]
menu = ["See the agency organigram."
       ,"Recruit agent."
       ,"Manage unassigned agents."
       ,"Manage assigned agents."
       ,"End turn."]

menuFunctions :: [BadIntel -> InputT IO BadIntel]
menuFunctions = [agencyOrg
                ,menuRecruitment
                ,menuManagementUn
                ,menuManagementAs
                ,endTurn]

agencyOrg :: BadIntel -> InputT IO BadIntel
agencyOrg g = do mapM_ outputStrLn . getAgencyLineUp $ (g^.(ukAgency . organigram))
                 return g

menuRecruitment :: BadIntel -> InputT IO BadIntel
menuRecruitment g = do let pool = currentRecruitementPool g
                       c <- enterMenu . map agentLine $ pool
                       if c == 0 then return g
                                 else displayAgent (currentRecruitementPool g !! (c-1))
    where 
          displayAgent :: Agent -> InputT IO BadIntel
          displayAgent a = mapM_ outputStrLn (describe a)
                           >> recruitOrNot g a
                           >>= menuRecruitment
          recruitOrNot :: BadIntel -> Agent -> InputT IO BadIntel
          recruitOrNot g a = yesNo "Do you want to recruit this potential agent (y/N) ?" (recruitment a) g

recruitment :: Agent -> BadIntel -> InputT IO BadIntel
recruitment a = return . execState (process (recruit a)) 

menuManagementAs :: BadIntel -> InputT IO BadIntel
menuManagementAs = undefined

menuManagementUn :: BadIntel -> InputT IO BadIntel
menuManagementUn g = do let allAgents = g^.(ukAgency.unassigned)
                        c <- enterMenu . map agentLine $ allAgents
                        if c == 0 then return g
                                  else manageOne (allAgents !! (c-1)) g
endTurn = undefined

manageOne :: Agent -> BadIntel -> InputT IO BadIntel
manageOne a = enterMenu' manageOneChoices [setSalary a, assignTo a]
manageOneChoices = ["Set salary"
                     ,"Assign to a post"]
manageOneFunc = [setSalary
                  ,assignTo]
setSalary a g = undefined

assignTo :: Agent -> BadIntel -> InputT IO BadIntel
assignTo a g = do let available = getAvailableRanks (_organigram . _ukAgency $ g)
                  c <- enterMenu (getAgencyLineUp available)
                  let rank = fst $ flatten available !! (c-1)
                  return $ execState (process (assign rank a)) g

currentRecruitementPool :: BadIntel -> [Agent]
currentRecruitementPool = take 5 . view (ukAgency . potentialAgents)

agentLine a = _name a ++ " (" ++ showSkill (averageLevel a) ++ ")"
