{------------------------------------------------------------------------------
- Nombre del archivo: lambdajack.hs                                           -
- Realizado por:    Fabio    Castro     10-10132                              -
-                   Patricia Reinoso    11-10851                              -   
- Organización: Universidad Simón Bolívar                                     -
- Proyecto: LambdaJack - Lenguajes de Programación I                          -
- version: v0.7.0                                                             -
------------------------------------------------------------------------------}

module Main where

import LambdaJack
import Cards
import qualified System.Random as R
import System.IO


-- Tipo de datos para representar el estado de un juego
data GameState = GS {games      :: Int,		-- Cantidad de partidas jugadas
					 lambdaWins :: Int,		-- Cantidad de partidas ganadas por Lambda
					 name       :: String,	-- Nombre del jugador
					 generator  :: R.StdGen -- Generador de números al azar
					} deriving (Show)


-- La función 'welcome' da un mensaje de bienvenida al juego
welcome :: IO String 
welcome = return "Bienvenido a LamdaJack \nIndique su nombre"


{- La función 'currentState' muestra cuántas partidas se han jugado, cuántas ha 
 ganado Lambda y cuántas ha ganado el jugador
 g :: GameState = estado de juego
 Retorna: mensaje
-} 
currentState :: GameState -> IO ()
currentState g = putStrLn ( "\nDespués de " ++ (show.games)g ++ 
							" partidas Lambda ha ganado "  ++
							(show.lambdaWins)g ++ " y " ++ (name)g ++ 
							" ha ganado " ++ show ((games)g - (lambdaWins)g) 
							++ ".")

{- 
 La función 'continuePlaying' pregunta al jugador si desea seguir jugando o no. 
 Retorna: IO True si el jugador desea seguir jugando IO False en caso contrario
-}
continuePlaying :: IO Bool
continuePlaying = do
	putStrLn "\n¿Desea seguir jugando? [s/n]"
	hSetBuffering stdin NoBuffering	-- Coloca el handle especificado 
									--(entrada estándar) en el modo NoBuffering
	x <- getChar         				
	options x
	-- La función options devuelve True si el jugador desea finalizar el juego 
	-- ('s' 'S') o False en caso contrario ('n' 'N')
	-- Si se introduce cualquier otra opción se repite la pregunta
	where options x 
		|x == 's' || x == 'S' = return True
		|x == 'n' || x == 'N' = return False
		|otherwise = continuePlaying


{- 
 La función 'anotherCard' presenta al jugador sus cartas e indica su 
 puntuación. Representa el turno del jugador
 s  :: String = Nombre del jugador
 h1 :: Hand   = Mazo a repartir
 h2 :: Hand   = Mano del jugador
 Retorna: Tupla cuyo primer argumento es el mazo restante y el segundo la mano 
 		  del jugador
-}
anotherCard :: String -> Hand -> Hand -> IO (Hand, Hand)
anotherCard s h1 h2 = do
	if (busted h2)
	then return (h1,h2) 			
	else do
		playerMsg s h2 				
		putStrLn $ "¿Carta o Listo? [c/l]"
		hSetBuffering stdin NoBuffering 
		x <- getChar 					
		options x
		where options x 
			|x == 'c' || x == 'C' = anotherCard s (fst get) (snd get)
			|x == 'l' || x == 'L' = return (h1,h2)
			|otherwise 			  = anotherCard s h1 h2
				where 
					get = do
						let ht = maybeToHand (draw h1 h2)
					 	if (ht == (empty,empty))	 
						then (h1,h2)
			 			else ht


{- 
 La función 'playerMsg' muestra un mensaje al jugador. Indica  mano y puntuación
 s :: String = Nombre del jugador
 h :: Hand = Mano del jugador
 Retorna: Mensaje
-}
playerMsg :: String -> Hand -> IO ()
playerMsg s h = do
	putStr $ "\n" ++ s ++ ", tu mano es " ++ show h ++ ", suma " 
	         ++ show (value h) ++ ". "


{-
 La función 'lambdaMsg' muestra la mano y puntuación de Lambda
 h :: Hand = Mano de Lambda
 Retorna: Mensaje
-}
lambdaMsg :: Hand -> IO ()
lambdaMsg h = do 
	putStrLn $ "\nMi mano es " ++ show h ++ ", suma " ++ show (value h) ++ ". "


{-
 La función 'updateStatus' llama a funciones para actualizar el estado de juego 
 dependiendo de quién ganó la última partida
 h1 :: Hand = Mano de Lambda
 h2 :: Hand = Mano del jugador
 g  :: Estado de juego actual
 Retorna: Nuevo estado de juego
-}
updateState :: Hand -> Hand -> GameState -> IO GameState
updateState h1 h2 g = do
	if (value h1) == (value h2)
	then isTie g 							
	else aux (winner h1 h2)
		where 
			aux LambdaJack = winnerLambda g 
			aux You 		= winnerYou g 	


{-
 La función 'isTie' actualiza el estado de juego en caso de empate. 
 Muestra un mensaje.
 g :: estado actual del juego
 Retorna: Nuevo estado del juego
-}
isTie :: GameState -> IO GameState
isTie g = do
	putStrLn "\nEmpatamos, así que yo gano."
	return (GS ((games)g+1) ((lambdaWins)g+1) ((name)g) ((generator)g))


{-
 La función 'winnerLambda' actualiza el estado de juego en el caso donde Lambda 
 gana. Muestra un mensaje  
 g :: estado actual del juego
 Retorna: Nuevo estado del juego
-}
winnerLambda :: GameState -> IO GameState
winnerLambda g  = do
	putStrLn "\nYo gano."
	return (GS ((games)g+1) ((lambdaWins)g+1) ((name)g) ((generator)g))


{-
 La función 'winnerYou' actualiza el estado de juego en el caso donde el jugador
 gana. Muestra un mensaje  
 g :: estado actual del juego
 Retorna: Nuevo estado del juego
-}
winnerYou :: GameState -> IO GameState
winnerYou g  = do
	putStrLn "\nTú ganas."
	return (GS ((games)g+1) ((lambdaWins)g) ((name)g) ((generator)g))


{- 
 La función gameloop representa el ciclo de una partida que finaliza cuando el 
 jugador lo indique (sea durante la ejecución normal del programa o mediante 
 una interrupción por teclado)
-}

gameloop :: GameState -> IO ()
gameloop g = do

	let gen = R.split ((generator)g)
	-- Se prepara un mazo nuevo, luego se baraja, y se genera una mano inicial 
	-- con dos cartas para el jugador


	let initial = maybeToHand (draw (fst firstcard) (snd firstcard))
		where 
			firstcard = do
				let mazo = (shuffle (fst gen) fullDeck)
				let sec = maybeToHand (draw mazo empty)
				if (sec == (empty,empty)) 
				then (mazo,empty)
				else sec
	
	-- Se pregunta al jugador si desea otra carta o "se queda"
	changeturn <- anotherCard ((name)g) (fst initial) (snd initial)
	
	-- Se muestra por última vez la mano del jugador
	playerMsg ((name)g) (snd changeturn)

	if busted (snd changeturn)
	then putStrLn "Perdiste."	
	else putStrLn "Mi turno."
	
	-- Turno de Lambda (playLambda) con el mazo restante (fst changeturn)
	let lambdahand = playLambda (fst changeturn) 

	-- Muestra la mano final de Lambda
	lambdaMsg lambdahand

	-- Actualiza gamestate y muestra mensaje correspondiente
	newstate <- updateState lambdahand (snd changeturn) g

	-- Se muestra el estado actual del juego
	currentState newstate

	-- Se pregunta al jugador si desea continuar con el juego
	x <- continuePlaying
	if x 
	then gameloop (GS ((games)newstate) ((lambdaWins)newstate) ((name)newstate) (snd gen)) 					
	else putStrLn "\n\nFin del juego.\n"	

	-- main es una secuencia de instrucciones que representan Lambda-Jack
main =	welcome >>= (\c -> putStrLn c) >> getLine 
		>>= (\name->gameloop (GS 0 0 name (R.mkStdGen 42)))
