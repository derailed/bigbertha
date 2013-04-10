require 'uri'

module Bigbertha
  class Ref 
    include Bigbertha::Action
    
    attr_reader :url, :uri
    
    def self.evt_value;         :value;     end
    def self.evt_child_added;   :add_child; end
    def self.evt_child_changed; :mod_child; end
    def self.evt_child_removed; :rm_child;  end
    def self.evt_child_moved;   :mv_child;  end
                
    def initialize( url, auth_token=nil )
      @url        = url
      @uri        = URI.parse( @url )
      @auth_token = auth_token
    end                                
    
    def name
      parse_path[-1]
    end
                  
    def root
      return self if root?
      Bigbertha::Ref.new( @uri.scheme + '://' + @uri.host, @auth_token )
    end
    
    def root?
      @uri.path.empty? or @uri.path == "/"
    end
  
    def parent
      return nil if root?
      path = parse_path[0..-2].join( "/" )
      Bigbertha::Ref.new( root.uri.merge(path).to_s, @auth_token )
    end
    
    def child( *child_path )
      child_path = (child_path.is_a?(Array) ? child_path.join('/') : child_path )
      Bigbertha::Ref.new( "#{uri.to_s}/#{child_path}", @auth_token )
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