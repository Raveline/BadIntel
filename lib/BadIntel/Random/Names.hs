{- A simple random name generator for BadIntel.
Its main purpose is to produce random, identifiable names for the agents.
TODO : Extend the list of names.
TODO : Make the Russian names.

To ponder : there are many possibilities here.
For the time being, every name are generated at first. It gives a simple
way to avoid reusing the same elements. If we manage to get a big enough
list of names, it should be more than enough. It is now, however, very well
engineered.
A second solution would be to just have a generator of names, called at
the demand. But it would mean reducing the list each time an element has
been picked. -}

module BadIntel.Random.Names
(NameCollection(..)
,getNames
,listFromGender
,rebuildCollection)
where

import Control.Monad.Random
import System.Random.Shuffle

import BadIntel.Types.Common

data NameCollection = NameCollection { _female :: [String]
                                     , _male :: [String] }

ukMFirstNames :: [String]
ukMFirstNames = ["John", "William", "Edward", "Philip", "Frederick", "Stanley"
                , "Henry", "Toby", "Roy", "Stanley", "Jonas", "Stephen"
                , "Gabriel", "Charles", "Douglas", "Daniel", "David"
                , "Samuel", "Evelyn"]
ukFFirstNames :: [String]
ukFFirstNames = ["Jane", "Elizabeth", "Judith", "Edith", "Carol", "Agatha"
                , "Dorothy", "Connie", "Charlotte", "Meredith", "Enid"
                , "Imogen", "Miranda", "Julia", "Emily", "Anne", "Frances"
                , "Rebecca", "Katherine"]
ukLastNames :: [String]
ukLastNames = ["Smith", "Leamas", "Gold", "Smiley", "Guillam", "Alleline"
              , "Haydon", "Esterhase", "Bland", "Craw", "Enderby", "Westerby"
              , "Marshall", "Frost", "Collins", "Gordon", "Grant", "Scott"
              , "Jones", "Keynes", "Beauchamp", "Bacon", "Abberline"
              , "Joyce", "Keegan", "Oliver", "Fawkes", "Peter", "Anstead"
              , "Alton", "Baffin", "Armstrong", "Bertram", "Berry", "Booker"
              , "Baskerville", "Baxter", "Baron", "Bradshaw", "Bennet"
              , "Cavendish", "Castle", "Castner", "Brook", "Burleson"
              , "Chapman", "Burnside", "Canavan", "Conleth", "Crow"
              , "Cumberbatch", "Cummings", "Crichton", "Devin", "Devails"
              , "Defoe", "Ebbetts", "Earl", "Fairchild", "Ewing"]

ruMFirstNames :: [String]
ruMFirstNames = ["Alexandre", "Boris", "Félix", "Fiodor", "Gregor", "Heydar"
                ,"Igor", "Ivan", "Iouri", "Ievgueni", "Konon", "Léonid", "Mikhaïl"
                ,"Oleg", "Sergueï", "Vadim", "Viktor", "Vitali", "Viliov"
                ,"Vladimir", "Viatcheslav"]
ruFFirstNames :: [String]
ruFFirstNames = ["Anastasiya", "Aleksandra", "Ana", "Ekaterina", "Ielena"
                ,"Irina", "Katya", "Mariya", "Nadezhda", "Nika", "Polina"
                ,"Sofiya", "Sveltana", "Tatiana","Uliana", "Varvara", "Vera"
                ,"Yelizaveta", "Yeva"]
ruLastNames :: [String]
ruLastNames = ["Abakumov", "Alexeyev", "Aminev", "Anokhin", "Antonov"
              ,"Babanin", "Baranovsky", "Belinsky", "Bektherev", "Bychkov"
              ,"Veselovsky", "Volkov", "Voronin", "Golubev", "Garin"
              ,"Dementyev", "Dmitryev", "Dubinin", "Yerofeyev"
              ,"Zhabin", "Zurov", "Zhigunov", "Ivchenko", "Ismaylov"
              ,"Kapustin", "Konyakov", "Kudrin", "Kurbatov", "Krasotkin"
              ,"Korneyev", "Krutikov", "Kasharin", "Kuznetsov", "Lavrov"
              ,"Lesnichy", "Loginovsky", "Lvov", "Lyapunov", "Mesyats"
              ,"Moskvin", "Myasnikov", "Nekrasov", "Nemtsov", "Oborin"
              ,"Orlov", "Onegin", "Ovechking", "Pankratov", "Petrov"
              ,"Prazdnikov", "Prokhorov", "Revyagin", "Rodchenko"
              ,"Ryabkin", "Reznikov"]

getNames:: (MonadRandom m) => Country -> m NameCollection
getNames Uk     = do (ukf, ukm) <- shuffleNames ukFFirstNames ukMFirstNames ukLastNames
                     return $ NameCollection ukf ukm 
getNames Russia = do (ruf, rum) <- shuffleNames ruFFirstNames ruMFirstNames ruLastNames
                     return $ NameCollection ruf rum

{- Return a pair of list of predetermined, shuffle names.
First item in the pair are for female names.
Second item in the pair are for male names.-}
shuffleNames :: (MonadRandom m) => [String]                -- Female first names
                                   -> [String]             -- Male first names
                                   -> [String]             -- Last names
                                   -> m ([String], [String]) -- Pair of results
shuffleNames ffn mfn ln = do ffn' <- shuffleM ffn
                             mfn' <- shuffleM mfn
                             ln' <- shuffleM ln
                             return (zipConcat ffn' ln'
                                    ,zipConcat mfn' (reverse ln'))
    where zipConcat = zipWith concatNames
          concatNames fn ln' = concat [fn, " ", ln']

rebuildCollection :: Gender -> [String] -> NameCollection -> NameCollection
rebuildCollection Female ns col = col { _female = ns }
rebuildCollection Male ns col   = col { _male = ns }

listFromGender :: Gender -> NameCollection -> [String]
listFromGender Female = _female
listFromGender Male   = _male
