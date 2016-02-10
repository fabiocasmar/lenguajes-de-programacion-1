{------------------------------------------------------------------------------
- Nombre del archivo: Cards.hs                                                -
- Autor: Fabio Castro                                                         -
- Correo: fabiocasmar@gmail.com                                               -
- Organización: Universidad Simón Bolívar                                     -
- Proyecto: LambdaJack - Lenguajes de Programación I                          -
- version: v0.2.0                                                             -
-------------------------------------------------------------------------------}

-- module Cards: modulo que posee lo necesario para emular las cartas del juego LambdaJack 
module Cards (Card (Card),
			  Suit (Clubs, Diamonds, Spades, Hearts), 
			  Value (Numeric, Jack, Queen, King, Ace), 
			  Hand (H), 
			  empty, 
			  size,
			  cardValue) where

-- Card: tipo de dato carta, contiene el valor y la pinta de la carta
data    Card      = Card {value :: Value, suit :: Suit}
					deriving (Eq)

-- Suit: tipo de dato pinta, que contiene a que pinta pertenece
data    Suit      = Clubs | Diamonds | Spades | Hearts
					deriving (Eq)

-- Value: tipo de dato que indica el tipo de carta que es, A, 9...
data    Value     = Numeric Int | Jack | Queen | King | Ace
					deriving (Eq)
-- Hand: tipo de dato que permite emular la mano de un jugador, o un mazo de cartas.
newtype Hand      = H [Card]
					deriving (Eq)
-- instances Show Card, Suit, Value, que ayudan a imprimir las cartas en el formato deseado
instance Show Card where
	show (Card x y) = (show x) ++ (show y)

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

instance Show Hand where
	show (H a) = foldl (\x y-> (show y)++" "++x) (show (head a)) (tail a)

-- empty: nos devuelve una mazno vacía
empty :: Hand
empty = H []

-- size: nos devuelve el tamaño del mazo
size :: Hand -> Int
size (H []) = 0
size (H xs) = foldr (\x y -> y+1) 0 xs

-- cardValue: nos devuelve el valor de la carta en el LambdaJack
cardValue :: Card -> Int
cardValue (Card (Numeric x) _) = x
cardValue (Card (Jack) _)      = 10
cardValue (Card (Queen) _)     = 10
cardValue (Card (King) _)      = 10
cardValue (Card (Ace) _)       = 11