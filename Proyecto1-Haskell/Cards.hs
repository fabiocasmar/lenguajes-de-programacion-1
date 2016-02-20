{------------------------------------------------------------------------------
- Nombre del archivo: Cards.hs                                                -
- Realizado por:	Fabio 	Castro 		10-10132                   		      -
-					Patricia Reinoso 	11-10851                      		  -   
- Organización: Universidad Simón Bolívar                                     -
- Proyecto: LambdaJack - Lenguajes de Programación I                          -
- version: v0.3.0                                                             -
------------------------------------------------------------------------------}

-- module Cards: modulo que posee lo necesario para emular las cartas del 
-- juego LambdaJack 
module Cards (Card (Card),
			  Suit (Clubs, Diamonds, Spades, Hearts), 
			  Value (Numeric, Jack, Queen, King, Ace), 
			  Hand (H), 
			  empty, 
			  size) where

-- Suit: tipo de dato para representar los "palos" de la baraja francesa
data    Suit      = Clubs | Diamonds | Spades | Hearts
					deriving (Eq)

-- Value: tipo de dato para representar los valores de las cartas: 
-- 1-10, J, Q, K, y A
data    Value     = Numeric Int | Jack | Queen | King | Ace
					deriving (Eq)

-- Card: tipo de dato carta, contiene el valor y la pinta de la carta
data    Card      = Card {value :: Value, 
						  suit :: Suit}
						  deriving (Eq)

-- Hand: tipo de dato que permite emular la mano de un jugador o un mazo
newtype Hand      = H [Card]
					deriving (Eq)

-- instances Show Card, Suit, Value, que ayudan a imprimir las cartas en el formato deseado
instance Show Card where
	show (Card x y) = (show x) ++ (show y)

-- Se define show para cada constructor, cambiando su nombre por su símbolo
instance Show Suit where
	show Clubs    = "♧"
	show Diamonds = "♦"
	show Spades   = "♤"
	show Hearts   = "❤"

-- Se define show para mostrar el número o letra asociado a cada valor
instance Show Value where 
	show (Numeric x) = (show x)
	show Jack        = "J"
	show Queen       = "Q"
	show King        = "K"
	show Ace         = "A"

instance Show Hand where
	show (H a) = foldl (\x y-> (show y)++" "++x) (show (head a)) (tail a)

-- La función 'empty' produce una mano vacía
empty :: Hand
empty = H []

-- La función 'size' recibe una mano y determina cuántas cartas tiene
size :: Hand -> Int
size (H h) = length h
