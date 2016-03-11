=begin
	Nombre del archivo:  bfs.hs                                                
 	Realizado por:    Fabio    Castro     10-10132                              
                   	  Patricia Reinoso    11-10851                                   
 	Organización: Universidad Simón Bolívar                                     
 	Proyecto: Programación Orientada a Objetos - Lenguajes de Programación I                          
 	Versión: v0.5.0 
=end 

module Bfs

  def bfs(start)
    q          = []
    q.push(start)
    visit      = []
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
    raise "start debe tener modulo bfs." unless start.respond_to? :bfs
	start.bfs(start) { |n| return n if predicate.call(n) } 
  end

  def path(start, predicate)
  	raise "start debe tener modulo bfs." unless start.respond_to? :bfs
    f = { start => nil }
    start.bfs(start) do |n|
      f.keys.each do |x|
        if x == n
          n = x
        end
      end

      if predicate.call(n)
        pa = []
        while !(n.nil?) do
          pa.unshift(n)
          n = f[n]
        end
        return pa
      end
      n.each lambda { |h| f[h] = n }   
    end   
  end

  def walk (start, action)
  	raise "start debe tener modulo bfs." unless start.respond_to? :bfs
    v = []
    start.bfs(start) do |n| 
      action.call(n)
      v.push(n)
    end 
    return v
  end

end

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
include Bfs
	attr_accessor :value,   # Valor alamacenado en el nodo
                  :children # Arreglo de sucesores GraphNode

	def initialize(v,c)
		@value, @children = v, c
	end
	
	def each(b)
	    @children.each { |c| b.call(c) } unless @children.nil?
	end
end

class LCR
include Bfs
  attr_reader :value

  def fun_ver (s)
       if (s.value["side"] == :right)
       	side_in = "left"
       else
       	side_in = "right"
       end
       if (s.value[side_in].include?(:lobo) and s.value[side_in].include?(:cabra)) or
           (s.value[side_in].include?(:cabra) and s.value[side_in].include?(:repollo))
         false
       else 
         true
       end
  end 

  def initialize(side,left,right)
  	left.map!  { |c| c.to_sym }
    right.map! { |c| c.to_sym }
    side = side.to_sym
    @value = {
      "side"  => side,
      "left"  => left,
      "right" => right
    }

    left.each { |x| raise "Se introdujo una etiqueta erronea en el lado izquierdo." unless ((x ==:lobo)or(x ==:cabra)or(x ==:repollo)) }
    right.each { |x| raise "Se introdujo una etiqueta erronea en el lado derecho." unless ((x ==:lobo)or(x ==:cabra)or(x ==:repollo)) }
    raise "Se introdujo una etiqueta con lado erroneo." unless ((side==:left)or(side==:right))
    raise "Se ha introducido una cantidad de elementos incorrecta" unless (left.length + right.length == 3)
    raise "Ha introducido un elemento dos veces" unless ((left+right).uniq!).nil?
  end        

  def each(p)
    if @value["side"] == :left
        o = "left"
        d = "right"
    else
        o = "right"
        d = "left"
    end

    @value[o].each do |x|
        newo = Array.new(@value[o])
        newo.delete(x)
        newd = (Array.new(@value[d])).push(x)
        if o == "right"
        	ns = LCR.new(d,newd,newo)
       	else 
          ns = LCR.new(d,newo,newd)
       	end
        p.call(ns) if fun_ver(ns)
    end

    ns = LCR.new(d,@value["left"],@value["right"])
    p.call(ns) if fun_ver(ns)
  end

  def ==(comp)
    if comp.is_a?LCR
        ((@value["side"]           == comp.value["side"])) and
        ((@value["right"]).sort()  == (comp.value["right"]).sort()) and
        ((@value["left"]).sort()   == (comp.value["left"]).sort())
    else
		false
	end
  end
  
  def solve
  	raise "El estado que ha introducido es invalido" unless self.fun_ver(self)
    o = LCR.new(:right,[],[:repollo,:cabra,:lobo])
    p = lambda { |x| x == o }
    path(self,p).each { |m| puts m.value }
    return true
  end

end
