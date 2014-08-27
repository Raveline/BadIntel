module BadIntel.Types.Agent
( Agent (..)
 ,Name
 ,Skill
 ,showSkill
 ,describe )
where

{- The first name and last name of an agent -}
type Name = String

{- A measure of an agent competence.
Should be between 1 and 20 -}
type Skill = Int

{- A simple Agent, member of an intelligence agency. -}
data Agent = Agent { _name          :: Name
                   , _collecting    :: Skill
                   , _analyzing     :: Skill
                   , _fighting      :: Skill
                   , _convincing    :: Skill
                   , _hiding        :: Skill
                   , _loyalty       :: Skill
                   , _salary        :: Int }
              deriving(Eq)

instance Show Agent where
    show = _name

{- Give a wordly description from a skill level -}
showSkill :: Skill -> String
showSkill skill
    | skill < 5 = "Pityful"
    | skill < 8 = "Bad"
    | skill < 13 = "Average"
    | skill < 16 = "Good"
    | otherwise = "Excellent"

skillDescriptions :: [String]
skillDescriptions = ["collecting information"
                    , "analyzing information"
                    , "physical tasks"
                    , "convincing others"
                    , "staying hidden"
                    , "obeying orders"]

skillExtractions :: [Agent -> Skill]
skillExtractions = [_collecting, _analyzing, _fighting
                   ,_convincing, _hiding, _loyalty]

{-- Return a multiline descriptionf of an agent. --}
describe :: Agent -> [String]
describe a = name:salary:skillStrings
    where name = "Agent " ++ _name a ++ ":"
          skillLevels = [f a | f <- skillExtractions]
          skillMarks = map showSkill skillLevels
          skillStrings = zipWith (\lvl desc -> lvl ++ " at " ++ desc)
                         skillMarks skillDescriptions
          salary = "This agent is payed " ++ show (_salary a) ++ " monthly."

