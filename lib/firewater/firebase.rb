require 'firewater/ref'

module Firewater
  class Firebase
    include Firewater::Ref
    
    attr_reader :url, :uri
    
    class NoDataError           < RuntimeError; end
    class InvalidRequestError   < RuntimeError; end
    class InvalidJSONError      < RuntimeError; end
    class PermissionDeniedError < RuntimeError; end
    class NonNumericFieldError   < RuntimeError; end    
            
    def initialize( url, auth_token=nil )
      @url        = url
      @uri        = URI.parse( @url )      
      @auth_token = auth_token
    end

    def inc( field )
      map = read
      current_val = map[field]
      raise NonNumericFieldError, "The field #{field} does not have a numeric value" if current_val and !current_val.is_a? Numeric
      if current_val
        new_val = map[field] + 1        
      else 
        new_val = 0
      end
      update( field => new_val )
    end
    
    def dec( field )
      map = read
      current_val = map[field]
      raise NonNumericFieldError, "The field #{field} does not have a numeric value" if current_val and !current_val.is_a? Numeric
      if current_val
        new_val = map[field] - 1        
      else
        new_val = 0
      end
      update( field => new_val )
    end
    
    def get_rules
      location = rules_url
      resp     = Typhoeus.get( location, gen_opts )
      handle_response( resp, location )       
    end
    
    def set_rules( rules )
      location = rules_url
      resp     = Typhoeus.put( location, gen_opts( body: {:rules => rules}.to_json ) )
      handle_response( resp, location )
    end
            
    def read
      location = json_url
      resp = Typhoeus.get( location, gen_opts( params: {format: :export} ) )
      res  = handle_response( resp, location )
      res.is_a?(Map) ? Snapshot.new( res ).to_map : res.is_a?(String) ? res.to_val : res
    end
            
    def set( data )
      location = json_url
      resp = Typhoeus.put( location, gen_opts( body: data.to_json ) )
      handle_response( resp, location )
    end

    def update( data )
      location = json_url
      resp = Typhoeus.patch( location, gen_opts( body: data.to_json ) )
      handle_response( resp, location )
    end
    
    def remove
      location = json_url
      resp = Typhoeus.delete( location, gen_opts )
      unless resp.success?
        raise InvalidRequestError, "<#{resp.return_code}> Unable to perform request #{location}"
      end
    end
  
    def push( data=nil )
      location = json_url
      opts     = {}      
      if data
        opts[:body] = data.to_json
      else
        opts[:body] = ''.to_json
      end
      resp = Typhoeus.post( location, gen_opts( opts ) )
      res = handle_response( resp, location )
      Firewater::Firebase.new( uri.to_s + '/' + res.name )
    end
  
    def set_priority( priority )
      location = json_url( true )
      resp = Typhoeus.put( location, gen_opts( body: priority.to_json ) )
      unless resp.success? or resp.body
        raise InvalidRequestError, "<#{resp.return_code}> Unable to perform request #{location}"
      end
    end
    
    def get_priority
      location = json_url( true )      
      resp = Typhoeus.get( location, gen_opts( params: { format: :export} ) )
      res = handle_response( resp, location )
      res.to_i
    rescue NoDataError
      nil
    end
      
    def auth
      raise 'NIY'
    end  
    def unauth
      raise 'NIY'
    end
                
    private
   
    def gen_opts( opts={} )
      if @auth_token
        opts[:params] ||= {}
        opts[:params][:auth] = @auth_token 
      end
      opts
    end
          
    def handle_response( resp, location )
      if resp.response_code == 403
        raise PermissionDeniedError, "No permission for #{location}"
      end
      unless resp.success?
        raise InvalidRequestError, "<#{resp.return_code}> Unable to perform request #{location}"
      end
      if resp.body.empty? or resp.body == "null"
        raise NoDataError, "No data found at location #{location}"
      end
      results = check_json( resp.body )
      results ? (results.is_a?(Hash) ? Map( results ) : results ) : resp.body.gsub( /\"/, '' )        
    end
            
    def check_json( json )
      JSON.parse( json )
    rescue
      nil
    end    
  end
end