{-
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * # 
# Nombre del archivo: Cards.hs                                                #
# Autor: Fabio Castro                                                         #
# Correo: fabiocasmar@gmail.com                                               # 
# Organización: Universidad Simón Bolívar                                     #
# Proyecto: LambdaJack - Lenguajes de Programación I                          #
# version: v0.1.0                                                             #
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * # 
-}
--  3) Lambda-Jack

-- Jack,Queen,King,Ace,Numeric 2,Numeric 3,Numeric 4,Numeric 5,Numeric 6,Numeric 7,Numeric 8,Numeric 9

-- Clubs,Diamonds,Spades,Hearts
module Cards (Card (Card),
			  Suit (Clubs, Diamonds, Spades, Hearts), 
			  Value (Numeric, Jack, Queen, King, Ace), 
			  Hand (H), 
			  empty, 
			  size,
			  cardValue) where
data    Card      = Card {value :: Value, suit :: Suit}
					deriving (Eq)
data    Suit      = Clubs | Diamonds | Spades | Hearts
					deriving (Eq)
data    Value     = Numeric Int | Jack | Queen | King | Ace
					deriving (Eq)
newtype Hand      = H [Card]
					deriving (Eq)

-- data    Triple  = ( Hand, Hand, Int)

instance Show Card where
	show (Card x y) = (show x) ++ (show y)
--
--instance Show Player where
--	show LambdaJack    = "LambdaJack"
--	show You 		   = "You"
--
instance Show Suit where
	show Clubs    = "♧"
	show Diamonds = "♢"
	show Spades   = "♤"
	show Hearts   = "❤"

instance Show Value where 
	show (Numeric x) = (show x)
	show Jack        = "J"
	show Queen       = "Q"
	show King        = "K"
	show Ace         = "A"
--
--
--instance Show GameState where
--	show (GS w x y z) = ("GS"++
--							" "++(show w)++
--							" "++(show x)++
--							" "++(show y)++
--							" "++(show z)) 
--
instance Show Hand where
	show (H a) = foldl (\x y-> (show y)++" "++x) (show (head a)) (tail a)
--
--instance Eq Hand where
--	(H x) == (H y) = x==y 
--
--instance Eq Suit where 
--	Clubs 		== Clubs     = True
--	Diamonds 	== Diamonds	 = True
--	Spades 		== Spades	 = True
--	Hearts 		== Hearts    = True
--	x			== y		 = False 
--
--instance Eq Value where 
--	Numeric x 	== Numeric y = (x==y)
--	Jack 		== Jack 	 = True
--	Queen 		== Queen	 = True
--	King 		== King		 = True
--	Ace 		== Ace 		 = True
--	x 			== y 		 = False
--
--
--
--
--instance Eq Card where
--	(Card x1 y1) == (Card x2 y2) = (x1==x2)&&(y1==y2)


empty :: Hand
empty = H []

size :: Hand -> Int
size (H []) = 0
size (H xs) = foldr (\x y -> y+1) 0 xs

cardValue :: Card -> Int
cardValue (Card (Numeric x) _) = x
cardValue (Card (Jack) _)      = 10
cardValue (Card (Queen) _)     = 10
cardValue (Card (King) _)      = 10
cardValue (Card (Ace) _)       = 11