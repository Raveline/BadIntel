import Control.Monad.State
import System.Random
import System.Console.Haskeline
import Data.Char

import BadIntel.BadIntel
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
buildGame conf = do pool <- runStateT (buildPool 20 Uk) conf
                    return $ Game ukAgency' ukAgency' (fst pool)

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
                         c <- enterMenu . map _name $ pool
                         mapM_ outputStrLn $ describe (pool !! (c-1))
                         menu_recruitement g

menu_management = undefined
end_turn = undefined
