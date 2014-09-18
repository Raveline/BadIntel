module BadIntel.TestData where

import Control.Lens
import BadIntel.Types.Agent
import BadIntel.Types.Agency

{- The UK agency. Will probably be moved to some config file. -}
directorRank = (Rank "Director" Politics Nothing)

ukHierarchy :: Hierarchy
ukHierarchy = Hierarchy directorRank
            [Hierarchy (Rank "Political director" Politics Nothing)
                [Hierarchy (Rank "Foreign office liaison" Politics Nothing) []
                ,Hierarchy (Rank "Treasury negociator" Budget Nothing) []
                ,Hierarchy (Rank "Chief analyst" Intel (Just $ view analyzing)) 
                    [Hierarchy (Rank "Allies strategy analyst" Intel Nothing) []
                    ,Hierarchy (Rank "Sovietology analyst" Intel Nothing) []
                    ,Hierarchy (Rank "Third-world analyst" Intel Nothing) []]]
            ,Hierarchy (Rank "Intelligence director" Raw (Just $ view collecting))
              [Hierarchy (Rank "European director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "Soviet block director" Raw (Just$ view  collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "Asia director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "Africa director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "South-America director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "North-America director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]
              ,Hierarchy (Rank "Middle-East director" Raw (Just $ view collecting))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]] 
            ,Hierarchy (Rank "Operational director" Countering (Just $ view loyalty))
              [Hierarchy (Rank "Foreign actions director" OffensiveMissions (Just $ view hiding))
                [Hierarchy (Rank "Operative" OffensiveMissions Nothing) []
                ,Hierarchy (Rank "Operative" OffensiveMissions Nothing) []
                ,Hierarchy (Rank "Operative" OffensiveMissions Nothing) []]
              ,Hierarchy (Rank "Domestic actions director" DefensiveMissions (Just $ view fighting))
                [Hierarchy (Rank "Operative" DefensiveMissions Nothing) []
                ,Hierarchy (Rank "Operative" DefensiveMissions Nothing) []
                ,Hierarchy (Rank "Operative" DefensiveMissions Nothing) []]
              ,Hierarchy (Rank "Covert operations director" Infiltration (Just $ view convincing))
                [Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []
                ,Hierarchy (Rank "Operative" Raw Nothing) []]] 
            ,Hierarchy (Rank "Counter-intelligence director" Countering (Just $ view loyalty))
              [Hierarchy (Rank "Counter-terrorism director" Countering (Just $ view fighting))
                    [Hierarchy (Rank "Operative" Countering Nothing) []
                    ,Hierarchy (Rank "Operative" Countering Nothing) []
                    ,Hierarchy (Rank "Operative" Countering Nothing) []]
              ,Hierarchy (Rank "Counter-espionnage director" Countering (Just $ view analyzing))
                    [Hierarchy (Rank "Operative" Countering Nothing) []
                    ,Hierarchy (Rank "Operative" Countering Nothing) []
                    ,Hierarchy (Rank "Operative" Countering Nothing) []]]] 

ukAgency' = buildAgency ukHierarchy 
