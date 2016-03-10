=begin
	Nombre del archivo:  rps.hs                                                
 	Realizado por:    Fabio    Castro     10-10132                              
                   	  Patricia Reinoso    11-10851                                   
 	Organización: Universidad Simón Bolívar                                     
 	Proyecto: Programación Orientada a Objetos - Lenguajes de Programación I                          
 	Versión: v0.3
=end 

class Movement

	def to_s
		"#{self.class}"
	end

	def to_sym
		to_s.to_sym
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
		[1,0]
	end

	def scoreScissors m 
		[0,1]
	end
end

class Paper <  Movement

	def score m
		m.scorePaper self
	end

	def scoreRock m
		[0,1]	
	end

	def scorePaper m 
		[0,0]
	end

	def scoreScissors m 
		[1,0]
	end
end

class Scissors < Movement

	def score m
		m.scoreScissors self
	end

	def scoreRock m
		[1,0]
	end

	def scorePaper m 
		[0,1]
	end

	def scoreScissors m 
		[0,0]
	end
end

class Strategy
	SEED = 42

	def to_s
		"#{self.class}"
	end

	def next m 
		raise "Esta clase no tiene metodo Next"
	end

	def reset
	end
end

class Uniform < Strategy

	attr_accessor :gen
	attr_reader :l

	def initialize l
		self.l = l
		self.gen = Random.new(SEED)
	end

	def next m
		n = @gen.rand(self.l.length)
		eval(self.l[n].to_s).new
	end

	def reset
		self.gen = Random.new(SEED)
	end
end

class Biased < Strategy

	attr_accessor :k, :v, :gen, :x, :sum, :l

	def initialize m
		self.k = m.keys
		self.v = m.values.inject(0, :+)
		self.gen = Random.new(SEED)
		self.x = []
		self.sum = 0
		self.l = m.each do |k,v| 
			v.times {self.x.push(k)}
			self.sum+=v
		end
	end


	def next m
		n = self.gen.rand(self.x.length)
		eval(self.x[n].to_s).new
	end

	def reset
		self.gen = Random.new(SEED)
	end
end

class Mirror < Strategy

	attr_accessor :last, :first

	def initialize  
		self.first = Uniform.new( [:Rock, :Paper, :Scissors]).next(0)
		self.last = self.first
	end

	def next m
		self.last = m
		if self.last == nil
			self.first
		else
			self.last
		end
	end

	def reset
		self.last = self.first
	end

	def to_s
		"#{self.class}. Primera jugada: #{@first.to_s}"
	end
end

class Smart < Strategy

	attr_accessor :first, :last

	def initialize
		self.first = Uniform.new( [:Rock, :Paper, :Scissors]).next(0)
		self.last = {:Rock => 0, :Paper => 0, :Scissors => 0}
	end

	def next m

		if m != nil
			self.last[m.to_sym] += 1
			gen = Random.new(SEED)
			n = gen.rand(self.last[:Rock] + self.last[:Paper] + self.last[:Scissors])
			
			if 0 <= n and n < self.last[:Paper]
				x =Scissors.new()
			elsif self.last[:Paper] <= n and n < self.last[:Paper] + self.last[:Rock]
				x = Paper.new()
			elsif self.last[:Paper] + self.last[:Rock] <= n and n < self.last[:Rock] + self.last[:Paper] + self.last[:Scissors]
				x = Rock.new()
			end
			puts self.last
			x
		else			
			puts self.last
			self.first
		end
		
	end

	def reset
		self.last = {:Rock => 0, :Paper => 0, :Scissors => 0}
	end

	def to_s
		"#{self.class}. Rock: #{self.last[:Rock]}, Paper: #{self.last[:Paper]}, Scissors: #{self.last[:Scissors]}"

	end
end

class Match
	
	attr_accessor :strategy1, :strategy2, :points1, :points2, :round, :move1, :move2

	def initialize p
		self.strategy1 = p[:Deepthought] 
		self.strategy2 = p[:Multivac]
		self.points1   = 0
		self.points2   = 0
		self.round    = 0
		self.move1 = nil
		self.move2 = nil
	end

	def rounds n
		n.times do
			self.move1, self.move2 = self.strategy1.next(self.move2) , self.strategy2.next(self.move1)
			res = self.move1.score self.move2
			self.points1 += res[0]
			self.points2 += res[1]
			self.round += 1
		end
		puts message
		self.restart
	end

	def upto n
		while self.points1 < n and self.points2 < n do
			self.move1, self.move2 = self.strategy1.next(self.move2) , self.strategy2.next(self.move1)
			res = self.move1.score self.move2 
			self.points1 += res[0]
			self.points2 += res[1]
			self.round += 1
		end
		puts message
		self.restart
	end

	def restart
		self.points1 = 0
		self.points2 = 0
		self.strategy1.reset
		self.strategy2.reset
		self.move1 = nil
		self.move2 = nil
	end

	private
	def message 
		{:Multivac => self.points2, :Deepthought => self.points1, :Rounds => self.round}
	end

end
