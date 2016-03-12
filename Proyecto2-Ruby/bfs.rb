=begin
	Nombre del archivo:  bfs.hs                                                
 	Realizado por:    Fabio    Castro     10-10132                              
                   	  Patricia Reinoso    11-10851                                   
 	Organización: Universidad Simón Bolívar                                     
 	Proyecto: Programación Orientada a Objetos - Lenguajes de Programación I                          
 	Versión: v0.9.0 
=end 


=begin
	El módulo Bfs contiene todas las funciones para la ejecución del bfs.
=end
module Bfs

=begin
	La función bfs realiza la ejecución del bfs de manera genérica, 
	haciendo uso de la función each de la clase, del objeto.
=end
    protected
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

=begin
	La función find recibe un nodo desde el cual se ejecutará bfs y un predicado. 
	Se devolverá el primer nodo que cumpla con el predicado.
=end
    public
    def find(start, predicate)
        raise "start debe tener modulo bfs." unless start.respond_to? :bfs
        start.bfs(start) { |n| return n if predicate.call(n) } 
    end

=begin
	La función path recibe un nodo desde el cual se ejecutará bfs y un predicado. 
	Se devolverá el camino desde el nodo start, hasta el primer nodo que cumpla el predicado.
=end
    public
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

=begin
	La función walk recibe un nodo desde el cual se ejecutará bfs y 
	un action que se ejecutará sobre  cada nodo. Se devolverá una lista
	con todos los nodos visitado.
=end
    public
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


=begin
	La clase BinTree, permite representar árboles binaros por un nodo.
=end
class BinTree
include Bfs
# Valor almacenado en el nodo
    attr_accessor :value
  
# BinTree izquierdo
    attr_accessor :left

# BinTree derecho    
    attr_accessor :right   

=begin
	La función initialize de BinTree permite crear un
	árbol binario e inicializarlo.
=end
    def initialize(v,l,r)
        raise "Solo se puede tener hijos de tipo BinTree o nil" unless (l.is_a? BinTree) or (l.nil?)
        raise "Solo se puede tener hijos de tipo BinTree o nil" unless (r.is_a? BinTree) or (r.nil?)
        self.value, self.left, self.right = v, l, r
    end

=begin
	La función each de BinTree, recibe un bloque que 
	sera utilizado para iterar sobre los
	hijos del nodo, cuando esten definidos.
=end
    def each(b)
        b.call(self.left)  unless self.left.nil?
        b.call(self.right) unless self.right.nil?
    end
end


=begin
	La clase GraphNode, permite representar Grafos por el nodo.
=end
class GraphNode
include Bfs

# Valor alamacenado en el nodo
    attr_accessor :value

# Arreglo de sucesores GraphNode
    attr_accessor :children 
   

=begin
	La función initialize de GraphNode permite crear un
	Grafo representado por un nodo, e inicializarlo.
=end
    def initialize(v,c)       
        raise "Solo se puede inicializar la lista de hijos como vacia o nil." unless (c.is_a? Array) or (c.nil?)
        c.each { |x| raise "Solo se puede tener hijos de tipo GraphNode" unless (x.is_a? GraphNode ) } unless (c.nil?) 
        self.value, self.children = v, c
    end

=begin
	La función each de GaphNode, recibe un bloque que 
	sera utilizado para iterar sobre los
	hijos del nodo, cuando esten definidos.
=end
    def each(b)
        (self.children.each { |c| b.call(c) }) unless self.children.nil? or self.children.empty?
    end
end

=begin
	La clase LCR tiene todo lo necesario para representar grafo 
	implícitos de expansión, los nodos representan los estado, 
	se hace uso de la clase bfs.
=end
class LCR
include Bfs

# En value se encuentra el estado actual, de que lado se encueentra que.
    attr_accessor :value

=begin
	La función fun_ver verifica si un nodo tiene una configuración
	válida, por ejemplo, un estado inválido es cuando están la cabra 
	y el lobo del mismo lado, y el bote se encuentra del otro lado.
=end
    protected
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

=begin
	La función initialize de LCR permite crear un
	Grafo implícito, e inicializarlo.
=end
    public
    def initialize(side,left,right)
        left.map!  { |c| c.to_sym }
        right.map! { |c| c.to_sym }
        side = side.to_sym
        self.value = {
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

=begin
	La función each de LCR, recibe un procedimiento que 
	sera utilizado para iterar sobre los hijos del estado,
	que serán generado al momento de requerirlos.
=end
    public
    def each(p)
        if self.value["side"] == :left
            o = "left"
            d = "right"
        else
            o = "right"
            d = "left"
        end
    
        self.value[o].each do |x|
            newo = Array.new(self.value[o])
            newo.delete(x)
            newd = (Array.new(self.value[d])).push(x)
            if o == "right"
                ns = LCR.new(d,newd,newo)
           	else 
                ns = LCR.new(d,newo,newd)
           	end
            p.call(ns) if fun_ver(ns)
        end
    
        ns = LCR.new(d,self.value["left"],self.value["right"])
        p.call(ns) if fun_ver(ns)
    end

=begin
	La función == de LCR, permite saber si dos
	 nodos LCR son iguales.
=end
    protected
    def ==(comp)
        if comp.is_a?LCR
            ((self.value["side"]           == comp.value["side"])) and
            ((self.value["right"]).sort()  == (comp.value["right"]).sort()) and
            ((self.value["left"]).sort()   == (comp.value["left"]).sort())
        else
            false
        end
    end

=begin
	La función solve de LCR hace uso de la función path del módulo Bfs 
	para resolver el grafo implícito y devolver la serie de estados 
	por los que pasar para llegar al estado objetivo.
=end
    public
    def solve
        raise "El estado que ha introducido es invalido" unless self.fun_ver(self)
        o = LCR.new(:right,[],[:repollo,:cabra,:lobo])
        p = lambda { |x| x == o }
        self.path(self,p).each { |m| puts m.value }
        return true
    end

end