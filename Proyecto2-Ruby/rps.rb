=begin
	Nombre del archivo:  rps.hs                                                
 	Realizado por:    Fabio    Castro     10-10132                              
                   	  Patricia Reinoso    11-10851                                   
 	Organización: Universidad Simón Bolívar                                     
 	Proyecto: Programación Orientada a Objetos - Lenguajes de Programación I                          
 	Versión: v0.0.0 
=end 

class Movement

	def to_s
	end

	def score(m)
	end
end

class Rock < Movement

end

class Paper <  Movement

end

class Scissors < Movement

end

class Strategy

	def next(m)
	end

	def to_s
	end

	def reset
	end
end

def rounds (n)
end

def upto(n)
end

def restart
end