{-
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * # 
# Nombre del archivo: lambdajack.hs                                           #
# Autor: Fabio Castro                                                         #
# Correo: fabiocasmar@gmail.com                                               # 
# Organización: Universidad Simón Bolívar                                     #
# Proyecto: LambdaJack - Lenguajes de Programación I                          #
# version: v0.1.0                                                             #
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * # 
-}
module Main where

import LambdaJack
import Cards
import System.Random

data 	GameState = GS {games::Int, lamdaWins::Int, name::String, generator::StdGen}
				    deriving (Show)

main :: IO ()
main = do
	(welcome)>>=(\y -> gameloop (newGS(y))) 


welcome :: IO String 
welcome = do
	putStrLn "Bienvenido a LamdaJack"
	putStrLn "Indique su Nombre"
	getLine


--gsG  :: GameState -> Int
--gsG  (GS w _ _ _) = w
--
--gsLj :: GameState -> Int
--gsLj (GS _ x _ _) = x
--
--gsY  :: GameState -> Int
--gsY  (GS w x _ _) = w-x
--
--gsYN :: GameState -> String
--gsYN  (GS _ _ y _) = y
--
--gsRn :: GameState -> StdGen
--gsRn  (GS _ _ _ z) = z

--setRn :: GameState -> StdGen -> GameState 
--setRn  (GS w x y _) f = (GS w x y f)
--
--setYN :: GameState -> String -> GameState 
--setYN  (GS w x _ z) f = (GS w x f z)
--

newGS :: String -> GameState 
newGS x = (GS 0 0 x (mkStdGen 42))

currentState :: GameState -> IO ()
currentState (GS w x y z) = do
	putStrLn ("Después de " ++ (show w) ++ 
			" partidas Lambda ha ganado " ++ (show x) ++ 
			" y " ++ y ++ " ha ganado " ++
			(show (w-x)))

perdiste :: IO ()
perdiste = putStrLn ". Perdiste."

miTurno :: IO ()
miTurno = putStrLn ". Mi turno."

yoGano :: IO ()
yoGano = putStrLn ". Yo gano."

tuGanas :: IO ()
tuGanas = putStrLn ". Tu ganas."

empate :: IO ()
empate = putStrLn "Empatamos, así que yo gano"

continuePlaying :: IO Bool
continuePlaying = do 
	putStrLn ""
	putStrLn "¿Desea seguir jugando?"
	c <- getLine
	let x = ((head c) == 'y')
	if ((length c) > 2) then  
		return False
	else
		return x

tuMano:: GameState -> Hand -> IO ()
tuMano (GS _ _  y _) ma = do
	putStr( y ++ ", tu mano es " ++ 
		(show ma) ++ ", suma " ++ (show(valueH ma)))

miMano::  Hand -> IO ()
miMano ma = do
	putStr("Mi mano es " ++ 
		(show ma) ++ ", suma " ++ (show(valueH ma)))

readCartaListo :: GameState -> Hand -> Hand -> IO ()
readCartaListo (GS w x y z) b c = do 
	let aux = maybeToHand (draw b c)
	let ply = playLambda b
	tuMano (GS w x y z) c
	if (busted c) then do
		perdiste
		(continuePlaying)>>= (\f -> if f then gameloop (GS (w+1) (x+1) y z) else putStrLn "Juego Finalizado")
	else do
		putStrLn ". ¿Carta o Listo? "
		(getLine)>>=(\g ->

			if (((head g)=='c') || ((head g)=='l') || ((head g)=='C') || ((head g)=='L'))&&
					((length g) < 2) then
				if ((head g)=='c')|| ((head g)=='C') then 
					readCartaListo (GS w x y z) (fst aux) (snd aux)
				else do
					tuMano (GS w x y z) c
					miTurno
					if (show (winner ply c)) == "LambdaJack"
						then do
							if (valueH ply)==(valueH c) then do
								miMano ply
								empate
							else do
								miMano ply
								yoGano	
							(continuePlaying)>>= (\f -> if f then gameloop (GS (w+1) (x+1) y z) else putStrLn "Juego Finalizado")
					else do
						miMano ply
						tuGanas
						(continuePlaying)>>= (\f -> if f then gameloop (GS (w+1) x y z) else putStrLn "Juego Finalizado")
			else do
				readCartaListo (GS w x y z) b c)

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
	readCartaListo (GS w x y z) (fst nuevosmazos2) (snd nuevosmazos2) 
