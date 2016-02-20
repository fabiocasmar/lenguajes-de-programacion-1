{------------------------------------------------------------------------------
- Nombre del archivo:  true.hs                                                -
-	Hecho por:	Fabio 	Castro 		10-10132                      -
-			Patricia Reinoso 	11-10851                      -   
- Organización: Universidad Simón Bolívar                                     -
- Proyecto: LambdaJack - Lenguajes de Programación I                          -
- version: v0.2.0                                                             -
------------------------------------------------------------------------------}

--  2) Verificador de Tautologías 
{-
 Tipo de datos recursivo monomórfico para representar expresiones de lógica 
 proposicional. Constructor para las constantes booleanas, variables, 
 negación, conjunción, disyunción e implicación.
-} 
data Proposition = Constant Bool 
				| Variable String
				| Negation Proposition
				| Conjunction Proposition Proposition
				| Disjunction Proposition Proposition
				| Implication Proposition Proposition

instance Show Proposition where
		show (Constant a)		    = show a
		show (Variable x)		    = show x
		show (Negation y)      	    = " ¬ " ++ show y
		show (Conjunction z w)  	= " ( " ++ show z ++ " ^ " ++ show w  ++ " ) "
		show (Disjunction v u)  	= " ( " ++ show v ++ " v " ++ show u  ++ " ) "
		show (Implication s t)    	= " ( " ++ show s ++ " => " ++ show t ++ " ) "

-- Tipo para ambientes de evaluación de una proposición lógica
type Environment = [(String,Bool)]

--		Ambiente de Evaluación
find :: Environment -> String -> Maybe Bool
find e k = foldl findAux Nothing e
			where 
				findAux (Just a) _ 	= Just a
				findAux _ (str,bool) = if str == k
								 	   then Just bool
								 	   else Nothing


addOrReplace :: Environment -> String -> Bool -> Environment
addOrReplace e k v = if find e k  == Nothing
						then (k,v):e
						else foldl addAux [] e
						where
							addAux nenv a@(str,bool) = 
								if str == k 
									then (str,v):nenv
									else a:nenv


remove :: Environment -> String -> Environment
remove e k = foldl (\x y -> if fst y == k then x else y:x) [] e

{-
 La función 'evalP' recorre una proposición apoyándose en un ambiente de 
 evaluación y calcula su valor de verdad
-} 
evalP :: Environment -> Proposition -> Maybe Bool

evalP _ (Constant b) 	  = Just b 		
evalP e (Variable s)      = find e s 
evalP e (Negation p)      = evalNegAux (evalP e p)	
							where 
								evalNegAux (Just p) = Just (not p)
								evalNegAux _ 	   = Nothing
evalP e (Conjunction p q) = evalConjAux (evalP e p) (evalP e q)
							where
								evalConjAux (Just p) (Just q) = Just (p && q)
								evalConjAux _ _ 	 		  = Nothing
evalP e (Disjunction p q) = evalDisjAux (evalP e p) (evalP e q)
							where
								evalDisjAux (Just p) (Just q) = Just (p || q)
								evalDisjAux _ _ 			  = Nothing

evalP e (Implication p q) = evalImpAux (evalP e p) (evalP e q)
							where 
								evalImpAux Nothing _ 		        = Nothing
								evalImpAux _ Nothing 		        = Nothing
								evalImpAux (Just True) (Just False) = Just False
								evalImpAux _ _				        = Just True

-- 		The truth shall set you free!
isTautology :: Proposition -> Bool
isTautology p = foldl (\x y -> f x (evalP y p)) True (aux(vars p))
	where 
		-- f evalua la conjunción entre Bool y un Just Bool
		f a (Just b) = a && b
		f _ _ 		 = error "No está definido"
		-- aux es una función auxiliar que genera la lista con todos los 
		-- ambientes de evaluación posibles para una lista de variables dada
		aux = foldr (\x y -> (map ((x,True):) y) ++ (map ((x,False):) y)) [[]] 

{-
 La función 'vars' extrae los nombres de variables de una proposición y los 
 retorna en una lista. Si una variable aparece más de una vez en una proposición, 
 la función garantiza que no se repitan.								
-}
vars :: Proposition -> [String]
vars p = varsAux p []
	where
		varsAux (Constant b) xs 	  = xs								
		varsAux (Variable s) xs 	  = if elem s xs then xs else s : xs	
		varsAux (Negation p) xs 	  = varsAux p xs							
		varsAux (Conjunction p q) xs  = varsAux p (varsAux q xs)						
		varsAux (Disjunction p q) xs  = varsAux p (varsAux q xs)
		varsAux (Implication p q) xs  = varsAux p (varsAux q xs)


{- PRUEBAS -}

x = Conjunction (Variable "a") (Variable "b")
y = Conjunction (Variable "c") (Variable "d")
z = Disjunction x y

w = Conjunction (Constant True) (Constant True)
w1 = Disjunction (Variable "b") (Constant True)
w2 = Conjunction (Constant True) (Variable "b")
w3 = Implication z w1
w4 = Conjunction (Constant False) (Variable "b")
w5 = Disjunction (Constant True) (Conjunction ( Variable "a") (Variable "b"))

--3.76 b
deb = Implication (Conjunction (Variable "p") (Variable "q")) (Variable "p")

--Una contradicción random
contrad = Conjunction (Implication (Variable "p") (Variable "q")) (Conjunction (Variable "p") (Negation (Variable "q")))

--Contingencia
conting= Disjunction (Variable "p") (Implication (Variable "q") (Variable "r"))

-- Implicaciones (tautologia)

impl = Implication (Conjunction (Implication (Variable "p") (Variable "q")) (Implication (Variable "q") (Variable "r"))) (Implication (Variable "p") (Variable "r"))

-- Random (tautologia)

rand1= Implication (Conjunction (Disjunction (Variable "p") (Variable "q")) 
					(Negation (Variable "q"))) (Variable "p")

-- (((p -> q) & (¬ p -> r)) & (¬ q -> ¬ r)) -> q

rand2 = Implication 
			(Conjunction 
				(Conjunction (Implication (Variable "p") (Variable "q")) (Implication (Negation (Variable "p")) (Variable "r"))) 
				(Implication (Negation (Variable "q")) (Negation (Variable "r")))) 
			(Variable "q")
