module BadIntel.Game.Mechanism
where

import Data.List
import Control.Lens
import Control.Monad.Trans.Free
import Control.Monad.State

import BadIntel.Lens.Tree
import BadIntel.Game.Update
import BadIntel.Types.Agent
import BadIntel.Types.Agency
import BadIntel.BadIntel

type Mission = String -- temporary

data BadIntelActionF n = 
    Recruit Agent n
    | Assign String Agent n
    | Order Mission Agent n
    | EndTurn n

instance Functor BadIntelActionF where
    fmap f (Recruit a n) = Recruit a (f n)
    fmap f (Assign s a n) = Assign s a (f n)
    fmap f (Order m a n) = Order m a (f n)
    fmap f (EndTurn n) = EndTurn (f n)

type BadIntelAction = FreeF BadIntelActionF
type BadIntelActionT = FreeT BadIntelActionF 

recruit :: (Monad m) => Agent -> BadIntelActionT m ()
recruit a = liftF $ Recruit a ()

assign :: (Monad m) => String -> Agent -> BadIntelActionT m ()
assign s a = liftF $ Assign s a ()

order :: (Monad m) => String -> Agent -> BadIntelActionT m ()
order m a = liftF $ Order m a ()

process :: BadIntelActionT (State BadIntel) n -> State BadIntel n
process a = runFreeT a >>= process'

process' :: BadIntelAction n (BadIntelActionT (State BadIntel) n) -> State BadIntel n
process' (Pure r) = return r
process' (Free (Recruit a n)) = do (ukAgency . unassigned) %= ((:) a)
                                   (ukAgency . potentialAgents) %= (delete a)
                                   process n
process' (Free (Assign s a n)) 
    = do org <- use (ukAgency . organigram)
         let lens = findLens (s, Nothing) org
         ukAgency.organigram.lens .= (s, Just a) -- Put agent in the tree
         (ukAgency.unassigned) %= (delete a)     -- Remove from unassigned pool
         process n
process' (Free (Order m a n)) = undefined
process' (Free (EndTurn n)) = do ukAgency %= updateAgency
                                 ruAgency %= updateAgency
                                 process n
