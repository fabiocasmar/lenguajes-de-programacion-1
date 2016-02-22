{------------------------------------------------------------------------------
- Nombre del archivo: LambdaJack.hs                                           -
- Realizado por:    Fabio    Castro     10-10132                              -
-                   Patricia Reinoso    11-10851                              -   
- Organización: Universidad Simón Bolívar                                     -
- Proyecto: LambdaJack - Lenguajes de Programación I                          -
- version: v0.5.0                                                             -
------------------------------------------------------------------------------}

-- module LambdaJack: módulo que contiene todo lo necesario para emular el juego 
module LambdaJack (
		Player (LambdaJack, You),
		value,
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

-- Player: Tipo de datos para los dos jugadores de Lambda-Jack
data    Player    = LambdaJack | You
				    deriving (Show)


-- La función 'value' recibe una mano y retorna el valor numérico de ella
value :: Hand -> Int
value (H xs) = if fst res > 21 
			   then fst res - (snd res) * 10 
			   else fst res
				-- res es una tupla cuyo fst contiene el valor numérico de la 
				-- mano, y snd contiene la cantidad de Aces de la mano
 				where res = foldr (\x (y1,y2) -> 	
					let v = cardValue x 
						-- La función cardValue determina el valor numérico de 
						-- una carta según las reglas de Lambda-Jack
						where
							cardValue (Card (Numeric n) _)	= n
							cardValue (Card Ace _)			= 11
							cardValue (Card _ _)			= 10
					-- Si el valor numérico es mayor a 21, 
 					-- los Aces valen 1 en lugar de 11
					in if v==11 
					   then (y1+v,y2+1) 
					   else (y1+v,y2)) (0,0) xs 


-- La función 'busted' recibe una mano e indica si "explotó" por exceder 21 																			
busted :: Hand -> Bool
busted h = value h > 21


{- La función 'winner' compara la mano del jugador con la de Lambda para 
 determinar el ganador. 
 h1 :: Hand = Mano de lambda
 h2 :: Hand = Mano del jugador
 Retorna: Jugador ganador.
-}
winner :: Hand -> Hand -> Player
winner h1 h2 = if busted h1 && busted h2   then LambdaJack 		
			   else if busted h2           then LambdaJack 				
			   else if busted h1 		   then You 					
			   else if value h1 < value h2 then You 	
			   else LambdaJack 	

-- La función 'fullDeck' devuelve un mazo completo de la baraja
fullDeck :: Hand
fullDeck = H [Card x y | x<-map (Numeric)[2..10] ++ [Jack , Queen , King , Ace],
				         y<-[Clubs , Diamonds , Spades , Hearts] ]


{- La función 'draw' retira la primera carta del mazo de cartas y la añade a la
 mano del jugador, si es posible
 Arg1 :: Hand = Mazo a repartir
 Arg2 :: Hand = Mazo del jugador
 Retorna = Tupla cuyo primer argumento es el mazo restante y el segundo la mano
           del jugador
-} 
draw :: Hand -> Hand -> Maybe (Hand,Hand)
draw (H [])     _    		= Nothing
draw (H mrs)    (H mjs) 	= Just ((H (tail mrs)), (H ((head mrs):mjs)))


-- maybeToHand: convierte un par Maybe (Hand,Hand) a (Hand,Hand) 
maybeToHand:: Maybe (Hand,Hand) -> (Hand,Hand)
maybeToHand t = maybe (empty, empty) id t


-- La función 'playLambda' recibe el mazo y retorna la mano de Lambda
playLambda :: Hand -> Hand 
playLambda m = playLambdaAux m empty
	where 
	playLambdaAux :: Hand -> Hand -> Hand 
	playLambdaAux m  n = do
		let mazo = maybeToHand (draw m n)
		if (value n) >= 16 
		then 	n
		else 	if (mazo == (empty,empty))	 
				then n
			 	else (playLambdaAux (fst mazo) (snd mazo)) 




-- shuffle:función que recibe una semilla pseudo aleatoria para barajar el mazo,
--		   tomando una carta aleatoria del mazo y colocandola en el otro mazo, 

shuffle :: StdGen -> Hand -> Hand
shuffle rn mazo@(H ys) = (snd4 (foldr (\_ x -> (randomCard x)) (mazo,empty,(size mazo),rn) ys))
	where 
	randomCard :: (Hand,Hand,Int,StdGen) -> (Hand,Hand,Int,StdGen)
	randomCard ((H a), (H b),c,d) = do
		let random = randomR (1,c) d
		let baraja = splitAt ((fst random)-1) a
		let mazo2  = (head (snd baraja)):b
		((H ((fst baraja)++(tail (snd baraja))),(H mazo2),(c-1),(snd random)))
	snd4:: (Hand,Hand,Int,StdGen) -> Hand
	snd4 (_,a,_,_) = a
