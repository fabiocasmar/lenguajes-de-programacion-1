{------------------------------------------------------------------------------
- Nombre del archivo: hof.hs                                                  -
-	Realizado por:	Fabio 	Castro 		10-10132
-					Patricia Reinoso 	11-10851                                                                            -
- Organización: Universidad Simón Bolívar                                     -
- Proyecto: LambdaJack - Lenguajes de Programación I                          -
- version: v0.3.0                                                             -
------------------------------------------------------------------------------}

--  1) Funciones de Orden Superior 

-- Implantación de filter utilizando listas por comprensión
filterC :: (a -> Bool) -> [a] -> [a]
filterC p xs = [x | x<-xs, p x]

-- Implantación de filter utilizando map (y otras funciones auxiliares)
filterC :: (a -> Bool) -> [a] -> [a]
filterM  p xs = concatMap (\x -> if (p x) == True then [x] else []) xs

-- Implantación de filter utilizando foldr
filterF :: (a -> Bool) -> [a] -> [a]
filterF p = foldr (\x y -> if p x then x:y else y) [] 
