=begin
	Nombre del archivo:  rps.hs                                                
 	Realizado por:    Fabio    Castro     10-10132                              
                   	  Patricia Reinoso    11-10851                                   
 	Organización: Universidad Simón Bolívar                                     
 	Proyecto: Programación Orientada a Objetos - Lenguajes de Programación I                          
 	Versión: v0.1
=end 

class Movement

	def to_s
		self.class
	end

end

class Rock < Movement

	def score m
		m.scoreRock self
	end

	def scoreRock m
		[0,0]
	end

	def scorePaper m 
		[0,1]
	end

	def scoreScissors m 
		[1,0]
	end
end

class Paper <  Movement

	def score m
		m.scorePaper self
	end

	def scoreRock m
		[1,0]	
	end

	def scorePaper m 
		[0,0]
	end

	def scoreScissors m 
		[0,1]
	end
end

class Scissors < Movement

	def score m
		m.scoreScissors self
	end

	def scoreRock m
		[0,1]
	end

	def scorePaper m 
		[1,0]
	end

	def scoreScissors m 
		[0,0]
	end
end

class Strategy
	SEED = 42

	def to_s
		self.class
	end

	def reset
	end
end

class Uniform < Strategy

	def initialize l
		@l = l
	end

	def next
		gen = Random.new(SEED)
		n = gen.rand(l.length-1)
		l[n]
	end
end

class Biased < Strategy

end

class Mirror < Strategy

	def initialize m 
		@initial = m
	end

end

class Smart < Strategy


end

class Match
	attr_accessor :s1, :s2,:ls1, :ls2, :p1, :p2, :rounds
	def initialize p
		@s1 = p[:Deepthought] 
		@s2 = p[:Multivac]
		@ls1 = []
		@ls2 = []
		@p1 = 0
		@p2 = 0
		@rounds = 0
	end

	def rounds n
		n.times do
			m1 = @s1.next
			m2 = @s2.next
			res = m1.score m2
			@p1 += res[0]
			@p2 += res[1]
			@rounds += 1
		end

	end

	def upto n
		while @p1 < n and @p2 < n do
			rounds 1
		end
	end

	def restart
		@ls1 = []
		@ls2 = []
		@p1 = 0
		@p2 = 0
	end

end
