{------------------------------------------------------------------------------- 
- Nombre del archivo: LambdaJack.hs                                           -
- Autor: Fabio Castro                                                         -
- Correo: fabiocasmar@gmail.com                                               - 
- Organización: Universidad Simón Bolívar                                     -
- Proyecto: LambdaJack - Lenguajes de Programación I                          -
- version: v0.2.0                                                             -
------------------------------------------------------------------------------}

-- module LambdaJack: módulo que contiene todo lo necesario para emular el juego LambdaJack
module LambdaJack (
		Player,
		valueH,
		cardValue,
		busted,
		winner,
		fullDeck,
		draw,
		maybeToHand,
		playLambda,
		shuffle
	) where

import Cards 
import System.Random

-- data Player: tipo de dato Player, que define si el jugador es Lambda o Tu
data    Player    = LambdaJack | You
				    deriving (Eq, Show)

-- valueH: función que permite calcular la suma del valor de las cartas de un mazo
valueH :: Hand -> Int
valueH (H [])  = 0
valueH (H xs)  = do
	let x = totalTemp (H xs)
	let y = (fst x)*11 + (snd x)

	if fst x == 0 then
		snd x
	else
		if (y < 21) then
			y
		else 
			(fst x)*1 + (snd x)
	where
	totalTemp :: Hand -> (Int,Int)
	totalTemp (H []) = (0,0)
	totalTemp (H xs) = foldr (\x y -> do 
						let x1 = cardValue x
						if x1 == 11
							then 
								(fst y + 1,(snd y)) 
							else 
								(fst y,(snd y)+(x1))) (0,0) xs

-- busted: función que ayuda a indicar si la suma del valor de las cartas de una mano es mayor a 21
busted :: Hand -> Bool
busted (H []) = False
busted (H xs) = if valueH (H xs) > 21 then True else False

-- winner: función que indica, dado dos jugadores, cual es el ganador
winner :: Hand -> Hand -> Player
winner mLY mY = if (busted mLY) 
				then 
					LambdaJack 
				else 
					if (busted mY)
						then 
							You
						else
							if valueH mY > valueH mLY then
								You
							else
								LambdaJack

-- fullDeck: haciendo uso de listas de compresión genera el mazo completo de cartas
fullDeck :: Hand
fullDeck = H [ Card i j | i <- [Jack,Queen,King,Ace,
								Numeric 2,Numeric 3,Numeric 4,
								Numeric 5,Numeric 6,Numeric 7,
								Numeric 8,Numeric 9,Numeric 1], 
					  j <- [Clubs,Diamonds,Spades,Hearts]]

-- draw: Si puede, toma la primera carta del mazo y la coloca en la otra mano
draw :: Hand -> Hand -> Maybe (Hand,Hand)
draw (H [])     (H mjs)     = Nothing
draw (H mrs)    (H mjs) 	= Just ((H (tail mrs)), (H ((head mrs):mjs)))

-- maybeToHand: convierte un par Maybe (Hand,Hand) a (Hand,Hand) 
maybeToHand:: Maybe (Hand,Hand) -> (Hand,Hand)
maybeToHand (Just x) = x
maybeToHand Nothing  = (empty,empty)

-- playLambda: función que emula la forma de jugar de Lambda, donde pide cartas hasta que tenga más de 16
playLambda :: Hand -> Hand 
playLambda m = playLambdaAux m empty
	where 
	playLambdaAux :: Hand -> Hand -> Hand 
	playLambdaAux m  n = do
		let mazo = maybeToHand (draw m n)
		if (valueH n) >= 16 
			then 
			 	n
			else 
				if (mazo == (empty,empty))
					then
						n
					else 
						(playLambdaAux (fst mazo) (snd mazo)) 




-- shuffle: función que recibe una semilla pseudo aleatoria para barajar el mazo,
--			 tomando una carta aleatoria del mazo y colocandola en el otro mazo, 
--			  hace uso de tuplas y fold
shuffle :: StdGen -> Hand -> Hand
shuffle rn (H ys) = H (snd4 (foldr (\_ x -> (randomCard x)) (ys,[],(size (H ys)),rn) ys))
	where 
	randomCard :: ([Card],[Card],Int,StdGen) -> ([Card],[Card],Int,StdGen)
	randomCard x = do
		let random = randomR (1,(thr4 x)) (frt4 x)
		let baraja = splitAt ((fst random)-1) (fst4 x)
		let mazo1  = (fst baraja)++(tail (snd baraja))
		let mazo2  = (head (snd baraja)):(snd4 x)
		((mazo1),(mazo2),((thr4 x)-1),(snd random))

	fst4 :: ([Card],[Card],Int,StdGen) -> [Card]
	fst4 (x,_,_,_) = x 

	snd4 :: ([Card],[Card],Int,StdGen) -> [Card]
	snd4 (_,x,_,_) = x 

	thr4 :: ([Card],[Card],Int,StdGen) -> Int
	thr4 (_,_,x,_) = x 

	frt4 :: ([Card],[Card],Int,StdGen) -> StdGen
	frt4 (_,_,_,x) = x