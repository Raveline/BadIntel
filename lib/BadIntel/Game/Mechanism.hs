module BadIntel.Game.Mechanism
where

import Data.List
import Control.Lens
import Control.Monad.Trans.Free
import Control.Monad.State

import BadIntel.BadIntel
import BadIntel.Types.Agent
import BadIntel.Types.Agency

type Mission = String -- temporary

data BadIntelActionF n = 
    Recruit Agent n
    | Assign String Agent n
    | Order Mission Agent n

instance Functor BadIntelActionF where
    fmap f (Recruit a n) = Recruit a (f n)
    fmap f (Assign s a n) = Assign s a (f n)
    fmap f (Order m a n) = Order m a (f n)

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
process' (Free (Assign s a n)) = undefined
process' (Free (Order m a n)) = undefined
