module BadIntel.Config.AgencyParser
where

import Control.Lens
import Control.Applicative hiding (many)
import BadIntel.Types.Agency
import BadIntel.Types.Agent
import Text.ParserCombinators.Parsec hiding (tab)

getOrganigram :: String -> Hierarchy
getOrganigram s = case parser of
                    Right o -> o
                    Left err -> error "Agency cannot be parsed !"
    where parser = parse (parseHierarchy 0) "" s

parseRank :: GenParser Char st Rank
parseRank = Rank <$> (manyTill anyChar rankType <* spaces)
                 <*> (rankType <* spaces)
                 <*> option Nothing (Just <$> stringToLens)

rankType :: GenParser Char st PositionOutput
rankType = choice [string "Raw" *> return Raw
                  ,string "Intel" *> return Intel
                  ,string "Politics" *> return Politics
                  ,string "Budget" *> return Budget
                  ,string "Countering" *> return Countering
                  ,string "Infiltration" *> return Infiltration
                  ,string "OffensiveMissions" *> return OffensiveMissions
                  ,string "DefensiveMissions" *> return DefensiveMissions]

parseHierarchy :: Int -> GenParser Char st Hierarchy
parseHierarchy n = Hierarchy <$> (count n tab *> parseRank)
                             <*> many (parseHierarchy (n+1))

tab = count 4 space

stringToLens = choice [string "analyzing" *> return (view analyzing)
                      ,string "hiding" *> return (view hiding)
                      ,try $ string "collecting" *> return (view collecting)
                      ,try $ string "convincing" *> return (view convincing)
                      ,string "fighting" *> return (view fighting)
                      ,string "loyalty" *> return (view loyalty)]
