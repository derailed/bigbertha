require 'basilik/ref'

module Basilik
  class Load
    include Basilik::Ref
    include Basilik::Action
    
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
  end
end