
--  2) Verificador de Tautologías 
-- 		Representación de Expresiones
data Proposition = Variable String
				| Negation Proposition
				| Conjunction Proposition Proposition
				| Disjunction Proposition Proposition
				| Conditional Proposition Proposition
				| Biconditional Proposition Proposition
			deriving Eq

instance Show Proposition where
		show (Variable x)		    = show x
		show (Negation y)      	    = "¬" ++ show y
		show (Conjunction z w)  	= "(" ++ show z ++ "^" ++ show w ++ ")"
		show (Disjunction v u)  	= "(" ++ show v ++ "or" ++ show u ++ ")"
		show (Conditional s t)    	= "(" ++ show s ++ "=>" ++ show t ++ ")"
		show (Biconditional p q)  	= "(" ++ show p ++ "<=>" ++ show q ++ ")"

type Variable = (String,Bool)

type Environment = [Variable] 

--		Ambiente de Evaluación
find :: Environment -> String -> Maybe Bool
find env k = mtl(foldr (\x y -> if fst x == k then [snd x] else y) [] env)
	where 
		mtl ::  [Bool] -> Maybe Bool
		mtl (x:_) = Just x
		mtl []    = Nothing

addOrReplace :: Environment -> String -> Bool -> Environment
addOrReplace env var val = if find env var == Nothing then
								(var,val):env
							else 
								foldr (\x y -> if fst x == var then (var,val):y else x:y) [] env

addOrReplace2 :: Environment -> String -> Bool -> Environment
addOrReplace2 env var val = foldr (\x y -> if fst x == var then (var,val):tail(y) else x:y) [(var,val)] env


remove :: Environment -> String -> Environment
remove env var = foldr (\x y -> if fst x == var then y else x:y) [] env

--		Evaluando valores de verdad
evalP :: Environment -> Proposition -> Maybe Bool
evalP env expr = do
	case expr of
		Variable      a   -> (find env a)
		Negation      a   -> (mnot (evalP env a))
		Conjunction   a b -> (mand (evalP env a) (evalP env b))
		Disjunction   a b -> (mor (evalP env a) (evalP env b))
		Conditional   a b -> (mor (evalP env a) (mnot (evalP env b)))
		Biconditional a b -> (mequival (evalP env a) (evalP env b))
		where
			mnot :: Maybe Bool -> Maybe Bool
			mnot (Just True)  = (Just False)
			mnot (Just False) = (Just True)
			mnot Nothing      = Nothing

			-- mor :: Maybe Bool -> Maybe Bool -> Maybe Bool
			mor (Just True)  _            = (Just True)
			mor _            (Just True)  = (Just True)
			mor (Just False) (Just False) = (Just False)
			mor Nothing      _            = Nothing
			mor _            Nothing      = Nothing

			-- mand :: Maybe Bool -> Maybe Bool -> Maybe Bool
			mand (Just True)  (Just True)  = (Just True)
			mand _            (Just False) = (Just False)
			mand (Just False) _            = (Just False)
			mand Nothing      _            = Nothing
			mand _            Nothing      = Nothing

			mequival :: Maybe Bool -> Maybe Bool -> Maybe Bool
			mequival (Just True)  (Just True)  = (Just True)
			mequival (Just False) (Just False) = (Just True)
			mequival (Just False) (Just True)  = (Just False)
			mequival (Just True)  (Just False) = (Just False)
			mequival Nothing      _            = Nothing
			mequival _            Nothing      = Nothing

-- 		The truth shall set you free!
isTautology :: Proposition ->  Bool
isTautology expr = 
	foldr (\x y -> if x == Just False then False else y) True (arreglo expr)
	where
		arreglo :: Proposition -> [Maybe Bool] 
		arreglo expr = foldr (\x y -> (evalP x expr):y) [] (foldr (\x y -> agregaVar x y) [[]] (vars expr))


		agregaVar :: String -> [Environment] -> [Environment]
		agregaVar a [[]] = [[(a,True)],[(a,False)]]
		agregaVar a b =  (foldr (\x y -> ((a,False):x):y) [[]] b) ++
							 (foldr (\x y -> ((a,True):x):y) [[]] b)

		vars :: Proposition -> [String]
		vars expr = do
			case expr of
				Variable      a   -> [a] 
				Negation	  a   -> vars a
				Conjunction   a b -> uconcat (vars a) (vars b)
				Disjunction   a b -> uconcat (vars a) (vars b)
				Conditional   a b -> uconcat (vars a) (vars b)
				Biconditional a b -> uconcat (vars a) (vars b)
				where
					uconcat z w  = foldr (\x y -> if already x y then y else x:y) z w
					already x [] = False
					already z w  = foldr (\x y -> if x == z then True else y) False w
