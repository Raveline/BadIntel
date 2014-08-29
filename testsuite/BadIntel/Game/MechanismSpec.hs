module BadIntel.Game.MechanismSpec
where

import Control.Monad.State
import Control.Lens
import Test.Hspec

import BadIntel.BadIntel
import BadIntel.Types.Agency
import BadIntel.Types.Agent hiding (describe)
import BadIntel.Game.Mechanism

main = hspec spec

agent1 = Agent "John Doe" 5 5 5 5 5 5 100
agent2 = Agent "Jane Doe" 5 5 5 5 5 5 100
agentPool = [agent1, agent2]

testGame = Game (ukAgency' agentPool) (ukAgency' agentPool)

-- apply :: (Monad m) => BadIntelActionT m () -> BadIntel -> BadIntel
apply f = snd . runState (process f)

gameAfterRecruitingAgent :: BadIntel
gameAfterRecruitingAgent = (recruit agent1) `apply` testGame 

spec = do
    context "When giving the recruit order" $ do
        it "Recruiting an agent remove it from the list of available agents" $ do
            (agent1 `elem` ( gameAfterRecruitingAgent^.(ukAgency . potentialAgents))) `shouldBe` False
        it "Recruiting an agent adds it to the list of unassigned agents" $ do
            (agent1 `elem` ( gameAfterRecruitingAgent^.(ukAgency . unassigned))) `shouldBe` True
