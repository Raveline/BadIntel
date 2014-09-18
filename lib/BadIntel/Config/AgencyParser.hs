module BadIntel.Config.AgencyParser
where

import Control.Lens
import Control.Applicative hiding (many, (<|>))
import BadIntel.Types.Agency
import BadIntel.Types.Agent
import Text.ParserCombinators.Parsec hiding (tab)

getOrganigram :: String -> Hierarchy
getOrganigram s = case parser of
                    Right o -> o
                    Left err -> error $ "Agency cannot be parsed ! "
                                ++ (show err)
    where parser = parse (parseHierarchy 0) "" s

parseRank :: GenParser Char st Rank
parseRank = Rank <$> parseName
                 <*> parseType
                 <*> parseBonus <* newline
    where parseName = manyTill anyChar (lookAhead $ try $ (spaces *> rankType))
          parseType = space *> rankType
          parseBonus = option Nothing 
                       (try $ space *> (Just <$> stringToLens))

rankType :: GenParser Char st PositionOutput
rankType = choice [string "Raw" *> stopSign *> return Raw
                  ,try $ string "Intel" *> stopSign *> return Intel
                  ,string "Politics" *> stopSign *> return Politics
                  ,string "Budget" *> stopSign *> return Budget
                  ,string "Countering" *> stopSign *> return Countering
                  ,try $ string "Infiltration" *> stopSign *> return Infiltration
                  ,string "OffensiveMissions" *> stopSign *> return OffensiveMissions
                  ,string "DefensiveMissions" *> stopSign *> return DefensiveMissions]

stopSign = lookAhead (space <|> newline)

parseHierarchy :: Int -> GenParser Char st Hierarchy
parseHierarchy n = Hierarchy <$> (try parseOneRank) <*> parseSub
    where parseOneRank :: GenParser Char st Rank
          parseOneRank = (count n tab *> parseRank)
          parseSub :: GenParser Char st [Hierarchy] 
          parseSub = many $ parseHierarchy (n+1)

tab = count 4 space

stringToLens = choice [string "analyzing" *> return (view analyzing)
                      ,string "hiding" *> return (view hiding)
                      ,try $ string "collecting" *> return (view collecting)
                      ,try $ string "convincing" *> return (view convincing)
                      ,string "fighting" *> return (view fighting)
                      ,string "loyalty" *> return (view loyalty)]
