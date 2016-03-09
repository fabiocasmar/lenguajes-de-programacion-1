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

	attr_accessor :l 

	def initialize l
		@l = l
		@gen = Random.new(SEED)
	end

	def next m
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


	def next m
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
		@first = Uniform.new( [:Rock, :Paper, :Scissors]).next(0)
		@last = @first
	end

	def next m
		@last = m
		if @last == nil
			@first
		else
			@last
		end
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
		@first = Uniform.new( [:Rock, :Paper, :Scissors]).next(0)
		@last = {:Rock => 0, :Paper => 0, :Scissors => 0}
	end

	def next m

		if @last[:Rock] + @last[:Paper] + @last[:Scissors] != 0
			gen = Random.new(SEED)
			n = gen.rand(@last[:Rock] + @last[:Paper] + @last[:Scissors])
			
			if 0 <= n and n < @last[:Paper]
				x =Scissors.new()
			elsif @last[:Paper] <= n and n < @last[:Paper] + @last[:Rock]
				x = Paper.new()
			elsif @last[:Paper] + @last[:Rock] <= n and n < @last[:Rock] + @last[:Paper] + @last[:Scissors]
				x = Rock.new()
			end
			@last[m.to_sym] += 1
		else			
			x = @first
		end
		
		puts @last
		x
	end

	def reset
		@last = {:Rock => 0, :Paper => 0, :Scissors => 0}
	end

	def to_s
		self.class
		"#{self.class}. Rock: #{@last[:Rock]}, Paper: #{@last[:Paper]}, Scissors: #{@last[:Scissors]}"

	end
end

class Match
	
	attr_accessor :s1, :s2,:ls1, :ls2, :p1, :p2, :rounds
	SEED = 42

	def initialize p
		@s1 = p[:Deepthought] 
		@s2 = p[:Multivac]
		@p1 = 0
		@p2 = 0
		@rounds = 0
		#@gen = Random.new(SEED)
		#@l = [:Rock, :Paper, :Scissors]
		#n = @gen.rand(3)
		#@initial1 = eval(@x[n].to_s).new
		#n = @gen.rand(3)
		#@initial2 = eval(@x[n].to_s).new
		@m1 = nil
		@m2 = nil
	end

	def rounds n
		n.times do
			@m1, @m2 = @s1.next(@m2) , @s2.next(@m1)
			res = @m1.score @m2
			@p1 += res[0]
			@p2 += res[1]
			@rounds += 1
		end
		puts message
		restart
	end

	def upto n
		while @p1 < n and @p2 < n do
			@m1, @m2 = @s1.next(@m2) , @s2.next(@m1)
			res = @m1.score @m2 
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
		@m1 = @initial1
		@m2 = @initial2
	end

	private
	def message 
		{:Multivac => @p2, :Deepthought => @p1, :Rounds => @rounds}
	end

end
