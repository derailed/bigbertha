require 'uri'

module Firewater
  module Ref      
    def name
      parse_path[-1]
    end
    
    def val
      read
    end
    
    def root
      return self if root?
      Firewater::Firebase.new( @uri.scheme + '://' + @uri.host )            
    end
    
    def root?
      @uri.path.empty? or @uri.path == "/"
    end
  
    def parent
      return nil if root?
      path = parse_path[0..-2].join( "/" )
      Firewater::Firebase.new( root.uri.merge(path).to_s )
    end
    
    def child( child_path )
      Firewater::Firebase.new( uri.merge( child_path.to_s ).to_s )
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
    
    def json_url( priority=nil )
      if @url =~ /\.json$/
        loc = @url
      elsif root?
        loc = @url + "/.json"
      else
        loc = @url + ".json"
      end
      priority ? loc.gsub( /\.json$/, "/.priority/.json" ) : loc
    end
    
    def rules_url
      @uri.merge( '.settings/rules.json' ).to_s      
    end
    
    private
              
    def parse_path
      @uri.path.split( "/" )
    end
  end
end