{------------------------------------------------------------------------------ 
- Nombre del archivo: lambdajack.hs                                           -
- Autor: Fabio Castro                                                         -
- Correo: fabiocasmar@gmail.com                                               - 
- Organización: Universidad Simón Bolívar                                     -
- Proyecto: LambdaJack - Lenguajes de Programación I                          -
- version: v0.3.0                                                             -
------------------------------------------------------------------------------}

module Main where

import LambdaJack
import Cards
import System.Random

-- data GameState: tipo de dato que emula el estado del juego, donde se guardan los valores de quien ha ganado.
data 	GameState = GS {games::Int, lamdaWins::Int, name::String, generator::StdGen}
				    deriving (Show)

-- welcome: función que imprime el mensaje de bienvenida y lee el nombre del jugador
welcome :: IO String 
welcome = do
	putStrLn "Bienvenido a LamdaJack"
	putStrLn "Indique su Nombre"
	getLine

-- newGs: función que recibe un nombre y devuelve un estado de juego nuevo
newGS :: String -> GameState 
newGS x = (GS 0 0 x (mkStdGen 42))

-- currentState: función que imprime el estado del juego
currentState :: GameState -> IO ()
currentState (GS w x y z) = do
	putStrLn ("Después de " ++ (show w) ++ 
			" partidas Lambda ha ganado " ++ (show x) ++ 
			" y " ++ y ++ " ha ganado " ++
			(show (w-x)))

-- perdiste: función auxiliar que imprime ". Perdiste."
perdiste :: IO ()
perdiste = putStrLn ". Perdiste."

-- miTurno: función auxiliar que imprime ". Mi turno."
miTurno :: IO ()
miTurno = putStrLn ". Mi turno."

-- yoGano: función auxiliar que imprime ". Yo gano."
yoGano :: IO ()
yoGano = putStrLn ". Yo gano."

-- tuGanas: función auxiliar que imprime ". Tu Ganas."
tuGanas :: IO ()
tuGanas = putStrLn ". Tu ganas."

-- empate: función auxiliar que imprime Empatamos, así que yo gano"
empate :: IO ()
empate = putStrLn ". Empatamos, así que yo gano."

-- continuePlaying: función que lee de la entrada y define si el jugador desea seguir jugando o no.
continuePlaying :: IO Bool
continuePlaying = do 
	putStrLn ""
	putStrLn "¿Desea seguir jugando?"
	c <- getLine
	if ((head c) == 'y') && ((length c) < 2) then
		return True
	else
		if ((head c) == 'n') && ((length c) < 2) then
			return False
		else 
			continuePlaying

-- tuMano: función que imprime la mano del jugador y el valor total.
tuMano:: GameState -> Hand -> IO ()
tuMano (GS _ _  y _) ma = do
	putStr( y ++ ", tu mano es " ++ 
		(show ma) ++ ", suma " ++ (show(valueH ma)))

-- miMano: función que imprime la mano de Lambd y el valor total.
miMano::  Hand -> IO ()
miMano ma = do
	putStr("Mi mano es " ++ 
		(show ma) ++ ", suma " ++ (show(valueH ma)))

-- partida: función que simular la partida a jugar
partida :: GameState -> Hand -> Hand -> IO ()
partida (GS w x y z) b c = do 
	tuMano (GS w x y z) c
	if (busted c) then do
		perdiste
		(continuePlaying)>>= (\f -> finalizador f (GS (w+1) (x+1) y z))
	else do
		putStrLn ". ¿Carta o Listo? "
		(getLine)>>=(\g -> selector (GS w x y z) b c g)
	where

		selector :: GameState -> Hand -> Hand -> String -> IO()
		selector (GS w x y z) b c g = do
			let aux = maybeToHand (draw b c)
			if (((head g)=='c') || ((head g)=='l') || ((head g)=='C') || ((head g)=='L'))&&
					((length g) < 2) then
				if ((head g)=='c')|| ((head g)=='C') then 
					partida (GS w x y z) (fst aux) (snd aux)
				else do
					let ply = playLambda b
					tuMano (GS w x y z) c
					miTurno
					miMano ply
					if (show (winner ply c)) == "LambdaJack"
						then do
							if (valueH ply)==(valueH c) then do
								empate
							else do
								yoGano	
							(continuePlaying)>>= (\f -> finalizador f (GS (w+1) (x+1) y z)) 
					else do
						tuGanas
						(continuePlaying)>>= (\f -> finalizador f (GS (w+1) x y z))
			else do
				partida (GS w x y z) b c

		finalizador :: Bool -> GameState -> IO ()
		finalizador f x = do
			if f then 
				gameloop x
			else do 
				putStrLn ""
				currentState x
				putStrLn "Juego Finalizado"


-- gameloop: función que simula el ciclo del juego
gameloop :: GameState -> IO ()
gameloop (GS w x y z) = do
	let mazobarajado = shuffle z fullDeck
	let manoJugador  = empty
	let nuevosmazos  = maybeToHand(draw mazobarajado manoJugador)
	let nuevosmazos2 = maybeToHand(draw (fst nuevosmazos) (snd nuevosmazos))
	putStrLn " "
	putStrLn " "
	currentState (GS w x y z)
	putStrLn " "
	partida (GS w x y z) (fst nuevosmazos2) (snd nuevosmazos2) 

-- main: Permite llamar a la función que hace la emulación del ciclo del juego
main :: IO ()
main = do
	(welcome)>>=(\y -> gameloop (newGS(y))) 
