module BadIntel.Game.MechanismSpec
where

import Control.Monad.State
import Control.Lens hiding (assign)
import Data.Tree.Lens
import Test.Hspec

import BadIntel.TestData
import BadIntel.BadIntel
import BadIntel.Types.Agency
import BadIntel.Types.Agent hiding (describe)
import BadIntel.Game.Mechanism

main = hspec spec

agent1 = Agent "John Doe" 5 5 5 5 5 5 100
agent2 = Agent "Jane Doe" 5 5 5 5 5 5 100
agent3 = Agent "Bill Doe" 5 5 5 5 5 5 100
agent4 = Agent "Kate Doe" 5 5 5 5 5 5 100
agentPool = [agent1, agent2]

testGame = Game (ukAgency' agentPool) (ukAgency' agentPool)
testGame' = testGame { _ukAgency = newAgency (_ukAgency testGame) }
    where newAgency a = a { _unassigned = [agent3, agent4] }

-- apply :: (Monad m) => BadIntelActionT m () -> BadIntel -> BadIntel
apply f = snd . runState (process f)

gameAfterRecruitingAgent :: BadIntel
gameAfterRecruitingAgent = (recruit agent1) `apply` testGame 

gameAfterAssigningAgent a = (assign directorRank a) `apply` testGame

spec = do
    context "When giving the recruit order" $ do
        it "Recruiting an agent remove it from the list of available agents" $ do
            (agent1 `elem` ( gameAfterRecruitingAgent^.(ukAgency . potentialAgents))) 
            `shouldBe` False
        it "Recruiting an agent adds it to the list of unassigned agents" $ do
            (agent1 `elem` ( gameAfterRecruitingAgent^.(ukAgency . unassigned))) 
            `shouldBe` True
    context "When assigning an agent to a position" $ do
        it "Gives an open position to an agent." $ do
            ( (gameAfterAssigningAgent agent3) ^.(ukAgency . organigram . root) ) 
            `shouldBe` (directorRank, Just agent3)
        it "Agent assigned are not in the unassigned list anymore." $ do
            (agent3 `elem` ( (gameAfterAssigningAgent agent3)^.(ukAgency . unassigned) )) 
            `shouldBe` False
        it "If agent was unassigned, but the position was not, the former agent assigned to that post is now unassigned."
            pending
        it "If agent had a position, and his new position was assigned, the former agent assigned to that position is now assigned to his successor previous position."
            pending
