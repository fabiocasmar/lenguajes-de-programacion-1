# encoding: UTF-8

=begin
	Nombre del archivo:  rps.hs                                                
 	Realizado por:    Fabio    Castro     10-10132                              
                   	  Patricia Reinoso    11-10851                                   
 	Organización: Universidad Simón Bolívar                                     
 	Proyecto: Programación Orientada a Objetos - Lenguajes de Programación I                          
 	Versión: v0.3
=end 

# Clase que representa la noción de movimiento ejecutado por un jugador
class Movement

	# Método para mostrar el movimiento como string
	def to_s
		"#{self.class}"
	end

	#Método para mostrar el movmiento como símbolo.
	def to_sym
		to_s.to_sym
	end
end

# Subclase que representa el movimiento específico Rock
class Rock < Movement

	# Método que invoca el método adecuado para una jugada contra Rock.
	def score m
		m.scoreRock self
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Rock vs. Rock
	def scoreRock m
		[0,0]
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Paper vs. Rock
	def scorePaper m 
		[1,0]
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Scissors vs. Rock
	def scoreScissors m 
		[0,1]
	end
end

# Subclase que representa el movimiento específico Paper
class Paper <  Movement

	# Método que invoca el método adecuado para una jugada contra Paper.
	def score m
		m.scorePaper self
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Rock vs. Paper
	def scoreRock m
		[0,1]	
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Paper vs. Paper
	def scorePaper m 
		[0,0]
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Scissors vs. Paper
	def scoreScissors m 
		[1,0]
	end
end

# Subclase que representa el movimiento específico Scissors
class Scissors < Movement

	# Método que invoca el método adecuado para una jugada contra Scissorss.
	def score m
		m.scoreScissors self
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Rock vs. Scissors
	def scoreRock m
		[1,0]
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Paper vs. Scissors
	def scorePaper m 
		[0,1]
	end

	# Método que retorna la ganancia de puntos resultado de la jugada Scissors vs. Scissors
	def scoreScissors m 
		[0,0]
	end
end

# Clase que representa un jugador. Permite generar el movimiento del jugador.
class Strategy
	
	# Constante que representa la semilla para generar los valores al azar.
	SEED = 42

	# Método que genera el próximo Movement.
	def next m 
		raise "Esta clase no tiene método Next."
	end

	# Método para llevar la estrategia a su estado inicial.
	def reset
	end

	# Método para retornar la estrategia como un string.
	def to_s
		"#{self.class}"
	end
end

# Subclase de Strategy. Selecciona cada movimiento usando una distribución 
# uniforme sobre los movimientos posibles.
class Uniform < Strategy

	attr_accessor :list, :gen

	# Constructor de la subclase Uniform. Recibe una lista de movimientos posibles.
	def initialize list
		if list.length < 1 
			raise "La lista #{list} no puede ser vacía"
		end
		self.list = list.uniq
		#x = self.list.each do |s|
		#	if not s.is_a?Strategy
		#		raise "Los elementos de la lista deben ser ':Rock', ':Paper' o ':Scissors'"
		#end
		self.gen = Random.new(SEED)
	end

	# Método que genera el próximo Movement. Usa una distribución uniforme.
	def next m
		n = @gen.rand(self.list.length)
		puts ("N")
		puts (n)
		eval(self.list[n].to_s).new
	end

	# Método que lleva la estrategia a su estado inicial. 
	# El generador vuelve a utilizar la semilla original.
	def reset
		self.gen = Random.new(SEED)
	end

	# Método que retorna la estrategia como un string.
	def to_s
		"#{self.class}. Posibles valores: #{self.list}"
	end
end

# Subclase de Strategy. 
class Biased < Strategy

	attr_accessor :gen, :list, :sum, :l, :map

	# Constructor de la subclase Biased. Recibe un mapa de movimientos posibles 
	# y sus probabilidades asociadas.
	def initialize m
		self.gen = Random.new(SEED)
		self.list = []
		self.sum = 0
		m.each do |k,v| 
			v.times {self.list.push(k)}
			self.sum+=v
		end
		self.map = m
	end

	# Método que genera el próximo Movement. Utiliza una distribución sesgada 
	# en base a probabilidades asociadas a movimientos.
	def next m
		#puts self.list
		n = self.gen.rand(self.list.length)
		puts ("N")
		puts (n)
		eval(self.list[n].to_s).new
	end

	# Método que lleva la estrategia a su estado inicial. 
	# El generador vuelve a utilizar la semilla original.
	def reset
		self.gen = Random.new(SEED)
	end

	# Método que retorna la estrategia como un string.
	def to_s
		"#{self.class}. Probabilidades asociadas: #{self.map}"
	end
end

# Subclase de Strategy. Siempre jugará lo mismo que jugó el contrincante en la 
# ronda anterior.
class Mirror < Strategy

	attr_accessor :last, :first

	# Constructor de la subclase Mirror. Define el primer movimiento.
	def initialize  
		self.first = Uniform.new( [:Rock, :Paper, :Scissors]).next(0)
		self.last = self.first
	end

	# Método que genera el próximo Movement. Retorna la última jugada del contrincante.
	def next m
		self.last = m
		if self.last.nil?
			self.first
		else
			self.last
		end
	end

	# Método que lleva la estrategia a su estado inicial.
	def reset
		self.last = self.first
	end

	# Método que retorna la estrategia como un string.
	def to_s
		"#{self.class}. Primera jugada: #{@first.to_s}"
	end
end

# Subclase de Strategy. Analiza las jugadas anteriores de su contrincante.
class Smart < Strategy

	attr_accessor :first, :last

	# Constructor de la subclase Smart. Define el primer movimiento.
	def initialize
		self.first = Uniform.new( [:Rock, :Paper, :Scissors]).next(0)
		self.last = {:Rock => 0, :Paper => 0, :Scissors => 0}
	end

	# Método que genera el próximo Movement basado en las frecuencias de las 
	# jugadas hechas por el oponente.
	def next m

		if not m.nil?
			self.last[m.to_sym] += 1
			gen = Random.new(SEED)
			n = gen.rand(self.last[:Rock] + self.last[:Paper] + self.last[:Scissors])
			puts ( "N")
			puts(n)
			if 0 <= n and n < self.last[:Paper]
				x =Scissors.new()
			elsif self.last[:Paper] <= n and n < self.last[:Paper] + self.last[:Rock]
				x = Paper.new()
			elsif self.last[:Paper] + self.last[:Rock] <= n and n < self.last[:Rock] + self.last[:Paper] + self.last[:Scissors]
				x = Rock.new()
			end
			puts self.last
			puts self.to_s
			x
		else			
			puts self.last
			puts self.to_s
			self.first
		end
		
	end

	# Método que lleva la estrategia a su estado inicial.
	def reset
		self.last = {:Rock => 0, :Paper => 0, :Scissors => 0}
	end

	# Método que retorna la estrategia como un string.
	def to_s
		"#{self.class}. Últimas jugadas del oponente: Rock: #{self.last[:Rock]}"\
		", Paper: #{self.last[:Paper]}, Scissors: #{self.last[:Scissors]}"

	end
end

# Clase que permite representar el estado del juego entre 2 jugadores.
class Match
	
	attr_accessor :strategy1, :strategy2, :points1, :points2, :round, :move1, :move2

	# Constructor de la clase Match. Recibe un mapa con los nombres y 
	# estrategias de los jugadores 
	def initialize p

		if p.length!= 2
			raise "Un Match solo puede ser creado con 2 jugadores."
		end
	 	
		self.strategy1 = p[:Deepthought] 
		self.strategy2 = p[:Multivac]

		if self.strategy1.nil? or self.strategy2.nil?
			raise "Las claves que representan los nombres de los jugadores en "\
				  "el mapa #{p} deben ser ':Deepthought' y ':Multivac'"
		elsif (not self.strategy1.is_a?Strategy) or (not self.strategy2.is_a?Strategy)
			raise "Los valores del mapa #{p} deben ser instancias de la clase Strategy"
		end

		self.points1 = 0
		self.points2 = 0
		self.round   = 0
		self.move1   = nil
		self.move2   = nil
	end

	# Método que completa n rondas en el juego.
	def rounds n
		n.times do
			self.move1, self.move2 = self.strategy1.next(self.move2) , self.strategy2.next(self.move1)
			puts ("MOVE 1")
			puts (self.move1)
			puts ("MOVE 2")
			puts (self.move2)
			res = self.move1.score self.move2
			puts ("RES")
			puts (res)
			self.points1 += res[0]
			self.points2 += res[1]
			self.round += 1
			puts message
		end
		puts message
		self.restart
	end

	# Método que completa tantas rondas como sea necesario hasta que alguno de 
	# los jugadores alcance n puntos.
	def upto n
		while self.points1 < n and self.points2 < n do
			self.move1, self.move2 = self.strategy1.next(self.move2) , self.strategy2.next(self.move1)
			puts ("MOVE 1")
			puts (self.move1)
			puts ("MOVE 2")
			puts (self.move2)
			res = self.move1.score self.move2 
			puts ("RES")
			puts (res)
			self.points1 += res[0]
			self.points2 += res[1]
			self.round += 1
			puts message
		end
		puts message
		self.restart
	end

	# Método que lleva el juego a su estado inicial.
	def restart
		self.points1 = 0
		self.points2 = 0
		self.strategy1.reset
		self.strategy2.reset
		self.move1 = nil
		self.move2 = nil
	end

	# Método privado que genera un mapa indicando los puntos obtenidos por cada 
	# jugador y la cantidad de rondas jugadas.
	private
	def message 
		{:Multivac => self.points2, :Deepthought => self.points1, :Rounds => self.round}
	end

end
