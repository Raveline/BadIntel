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
,getNames)
where

import Control.Monad.Random
import System.Random.Shuffle

data NameCollection = NameCollection { _englishFemale :: [String]
                                     , _englishMale :: [String]
                                     , _russianFemale :: [String]
                                     , _russianMale :: [String] }

ukMFirstNames = ["John", "William", "Edward", "Philip", "Frederick", "Stanley"
                , "Henry", "Toby", "Roy", "Stanley", "Jonas", "Stephen"
                , "Gabriel", "Charles", "Douglas", "Daniel", "David"
                , "Samuel", "Evelyn"]
ukFFirstNames = ["Jane", "Elizabeth", "Judith", "Edith", "Carol", "Agatha"
                , "Dorothy", "Connie", "Charlotte", "Meredith", "Enid"
                , "Imogen", "Miranda", "Julia", "Emily", "Anne", "Frances"
                , "Rebecca", "Katherine"]
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

ruMFirstNames = ["Alexandre", "Boris", "Félix", "Fiodor", "Gregor", "Heydar"
                ,"Igor", "Ivan", "Iouri", "Ievgueni", "Konon", "Léonid", "Mikhaïl"
                ,"Oleg", "Sergueï", "Vadim", "Viktor", "Vitali", "Viliov"
                ,"Vladimir", "Viatcheslav"]
ruFFirstNames = ["Anastasiya", "Aleksandra", "Ana", "Ekaterina", "Ielena"
                ,"Irina", "Katya", "Mariya", "Nadezhda", "Nika", "Polina"
                ,"Sofiya", "Sveltana", "Tatiana","Uliana", "Varvara", "Vera"
                ,"Yelizaveta", "Yeva"]
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

getNames:: (MonadRandom m) => m NameCollection
getNames = do (ukf, ukm) <- shuffleNames ukFFirstNames ukMFirstNames ukLastNames
              (ruf, rum) <- shuffleNames ruFFirstNames ruMFirstNames ruLastNames
              return $ NameCollection ukf ukm ruf rum

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
          concatNames fn ln = concat [fn, " ", ln]
