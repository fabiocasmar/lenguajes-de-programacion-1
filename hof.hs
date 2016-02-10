--  1) Funciones de Orden Superior 
--	 	Usando listas por comprensión
filterC fun [] = []
filterC fun xs = [ x | x <- xs, fun x ]

--		 Usando un map.

filterM  fun [] = []
filterM  fun xs = concat (map filIndividual xs)
	where 
		filIndividual x = 
						if (fun x) == True
							then 
								[x]
							else
								[]

--		Usando fold
filterF fun [] = []
filterF fun xs = foldr (\x y -> if fun x then x:y else y) [] xs
