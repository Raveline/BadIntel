module BadIntel.Config.AgencyParserSpec
where

import Test.Hspec
import Text.ParserCombinators.Parsec

import BadIntel.Config.AgencyParser
import BadIntel.TestData
import BadIntel.Types.Agency

desc = ["Director Politics"
        ,"    Political director Politics"
        ,"        Foreign office liaison Politics"
        ,"        Treasury negociator Budget"
        ,"        Chief analyst Intel analyzing"
        ,"            Allies strategy analyst Intel"
        ,"            Sovietology analyst Intel"
        ,"            Third-world analyst Intel"
        ,"    Intelligence director Raw collecting"
        ,"        European director Raw collecting"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"        Soviet block director Raw collecting"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"        Asia director Raw collecting"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"        Africa director Raw collecting"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"        South-America director Raw collecting"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"        North-America director Raw collecting"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"        Middle-East director Raw collecting"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"    Operational director Countering loyalty"
        ,"        Foreign actions director OffensiveMissions hiding"
        ,"            Operative OffensiveMissions"
        ,"            Operative OffensiveMissions"
        ,"            Operative OffensiveMissions"
        ,"        Domestic actions director DefensiveMissions fighting"
        ,"            Operative DefensiveMissions"
        ,"            Operative DefensiveMissions"
        ,"            Operative DefensiveMissions"
        ,"        Covert operations director Infiltration convincing"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"            Operative Raw"
        ,"    Counter-intelligence director Countering loyalty"
        ,"        Counter-terrorism director Countering fighting"
        ,"            Operative Countering"
        ,"            Operative Countering"
        ,"            Operative Countering"
        ,"        Counter-espionnage director Countering analyzing"
        ,"            Operative Countering"
        ,"            Operative Countering"
        ,"            Operative Countering"]

descAsString = unlines desc
simpleDesc = "Director Politics\n"
simpleRank = (Rank "Director" Politics Nothing)


simpleHierarchy = Hierarchy simpleRank []
parse' f s = case parse f "" s of
                Right x -> x
                Left err -> error (show err)

spec = do
        it "Can parse a simple rank" $ do
            parse' parseRank simpleDesc `shouldBe` simpleRank
        it "Can parse a single line of agency description" $ do
            getOrganigram simpleDesc `shouldBe` simpleHierarchy
        it "Hierarchy is stored in a config file that must be parsed." $ do
            getOrganigram descAsString `shouldBe` ukHierarchy
