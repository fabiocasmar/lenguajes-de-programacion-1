=begin
	Nombre del archivo:  bfs.hs                                                
 	Realizado por:    Fabio    Castro     10-10132                              
                   	  Patricia Reinoso    11-10851                                   
 	Organización: Universidad Simón Bolívar                                     
 	Proyecto: Programación Orientada a Objetos - Lenguajes de Programación I                          
 	Versión: v0.0.0 
=end 

class BinTree
include Bfs
	attr_accessor :value,  # Valor almacenado en el nodo
				  :left,   # BinTree izquierdo
				  :right   # BinTree derecho
	
	def initialize(v,l,r)
		@value, @left, @right = v, l, r
	end
	
	def each(b)
	    b.call(@left)  unless @left.nil?
	    b.call(@right) unless @right.nil?
	end
end

class GraphNode
	attr_accessor :value,   # Valor alamacenado en el nodo
				  :children # Arreglo de sucesores GraphNode

	def initialize(v,c)
		@value, @children = v, c
	end
	
	def each
	    @children.each do |c|
	      b.call(c)
	    end unless @children.nil?
	end
end

module Bfs
	def bfs(start)
		q 			 = []
		q.push(start)
		visit 		 = []
		pushear_nodo = lambda { |x| q.push(x) } 
		while(q.size != 0)
			n = q.shift
			if !visit.include? n
				n.each pushear_nodo 
				yield n 
				visit.push(n)
			end
		end
	end

	def find(start, predicate)
    	start.bfs(start) { |n| return n if predicate.call(n) }
    end

    def path(start, predicate)
    	f = { start => [] }
    	start.bfs(start) do |n|
			if predicate.call(n)
				pa = []
				while n != [] do
					pa.unshift(n)
					n = f[n]
				end
				return pa
			end
        	n.each lambda { |h| f[h] = n }   
        end		
	end

	def walk (start, action)
		v = []
		start.bfs(start) do |n| 
			action.call(n)
			v.push(n)
		end 
		v
	end

end



def LCR
	attr_reader :value
	
	#def initialize(?) # Indique los argumentos
	#	# Su c´odigo aqu´ı
	#end
	
	def each(p)
		# Su c´odigo aqu´ı
	end
	
	def solve
		# Su c´odigo aqu´ı
	end
end