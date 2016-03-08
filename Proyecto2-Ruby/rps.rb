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
		self.class
	end

	def reset
	end
end

class Uniform < Strategy

	attr_accessor :l 

	def initialize l
		@l = l
		@gen = Random.new(SEED)
	end

	def next
		n = @gen.rand(l.length)
		eval(l[n].to_s).new
	end

	def reset
		@gen = Random.new(SEED)
	end
end

class Biased < Strategy

	def initialize m
		@k = m.keys
		@v = m.values.inject(0, :+)
		@gen = Random.new(SEED)
		@x = []
		@sum = 0
		@l = m.each do |k,v| 
			v.times {@x.push(k)}
			@sum+=v
		end
	end


	def next
		n = @gen.rand(@x.length)
		eval(@x[n].to_s).new
	end

	def reset
		@gen = Random.new(SEED)
	end
end

class Mirror < Strategy
	attr_accessor :last

	def initialize  
		@first = Uniform.new( [:Rock, :Paper, :Scissors]).next
		@last = @first
	end

	def next
		@last
	end

	def reset
		@last = @first
	end

	def to_s
		"#{self.class}. Primera jugada: #{@first.to_s}"
	end
end

class Smart < Strategy

	attr_accessor :r,:p,:s, :first

	def initialize
		@first = Uniform.new( [:Rock, :Paper, :Scissors]).next
		@r = 0
		@p = 0
		@s = 0
	end

	def next
		if @r + @p + @s != 0
			gen = Random.new(SEED)
			n = gen.rand(@p + @r + @s - 1)
			
			if 0 <= n and n < p
				Scissors.new()
			elsif p <= n and n < @p + @r
				Paper.new()
			elsif @p + @r <= n and n < @p + @r + @s
				Rock.new()
			end
		else
			@first
		end
	end

	def reset
		@r = 0
		@p = 0
		@s = 0
	end

	def to_s
		self.class
		"#{self.class}. Rock: #{@r}, Paper: #{@p}, Scissors: #{@s}"

	end
end

class Match
	
	attr_accessor :s1, :s2,:ls1, :ls2, :p1, :p2, :rounds
	
	def initialize p
		@s1 = p[:Deepthought] 
		@s2 = p[:Multivac]
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
		puts message
		restart
	end

	def upto n
		while @p1 < n and @p2 < n do
			m1 = @s1.next
			m2 = @s2.next
			res = m1.score m2
			@p1 += res[0]
			@p2 += res[1]
			@rounds += 1
		end
		message
		restart
	end

	def restart
		@p1 = 0
		@p2 = 0
		@s1.reset
		@s2.reset
	end

	private
	def message 
		{:Multivac => @p2, :Deepthought => @p1, :Rounds => @rounds}
	end

end
