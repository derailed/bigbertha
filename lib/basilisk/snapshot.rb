module Basilisk
  class Snapshot
      
    class Node
      attr_accessor :priority, :name, :parent, :children, :value
    
      def initialize( name )
        @name     = name
        @priority = nil
        @children = []
        @value    = nil
        @parent   = nil
      end
    
      def add_child( child )
        child.parent = self
        children << child
      end
      
      def to_map
        map = Map.new
        order( map )
        map
      end
        
      def dump
        puts "#{'  '*level}#{name} [#{priority.inspect}] --#{value.inspect}"  
        children.sort_by do |c|
          if c.priority and c.priority.is_a? Integer
            "b_#{c.priority}_#{c.name}"
          elsif c.priority
            "z_#{c.priority}_#{c.name}"
          else
            "a_#{c.name}"
          end
        end.each do |c|
          c.dump
        end
      end
      
      private
      
      def order( map )
        map[name] = children.empty? ? value : Map.new
        children.sort_by do |c|
          if c.priority and c.priority.is_a? Numeric
            "b_#{'%05.2f' % c.priority}_#{c.name}"
          elsif c.priority
            "z_#{c.priority}_#{c.name}"
          else
            "a_#{c.name}"
          end
        end.each do |c|
          c.send( :order, map[name] )
        end
      end
             
      def level
        level = 0
        node  = self
        while node.parent do
          level +=1
          node = node.parent
        end
        level
      end
    end
  
    def initialize( map )
      @map = map
      @root = Node.new( 'root' )
      build( @map, @root )
    end
    
    def to_map
      @root.to_map.root
    end
    
    def dump
      @root.dump
    end
        
    private
  
    def build( map, root )
      map.each_pair do |k,v|
        node = Node.new( k )
        if v.is_a? Hash
          priority = v.delete('.priority')
          node.priority = priority if priority
          build( v, node )
        else
          node.value = v.is_a?(String) ? v.to_val : v
        end
        root.add_child( node )
      end
    end
  end
end