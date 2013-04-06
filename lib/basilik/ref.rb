require 'uri'

module Basilik
  module Ref      
    def name
      parse_path[-1]
    end
    
    def val
      read
    end
    
    def root
      return self if root?
      Basilik::Load.new( @uri.scheme + '://' + @uri.host )            
    end
    
    def root?
      @uri.path.empty? or @uri.path == "/"
    end
  
    def parent
      return nil if root?
      path = parse_path[0..-2].join( "/" )
      Basilik::Load.new( root.uri.merge(path).to_s )
    end
    
    def child( child_path )
      Basilik::Load.new( "#{uri.to_s}/#{child_path}" )
    end
      
    def child?( child_path )
      child( child_path ).read
      true
    rescue
      false
    end
  
    def children?
      data = read
      data.is_a? Map and !data.empty?
    end
    
    def num_children
      data = read
      if data.is_a? Map and !data.empty?
        data.count
      else
        0
      end
    end
      
    def to_s
      @url
    end
    
        
    private
              
    def parse_path
      @uri.path.split( "/" )
    end
  end
end