require 'json'
require 'typhoeus'
require 'map'

module Basilisk  
  LIBPATH      = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH         = ::File.dirname(LIBPATH) + ::File::SEPARATOR  
  
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))
    Dir.glob(search_me).sort.each { |rb| require rb }
  end  
end

Basilisk.require_all_libs_relative_to File.expand_path( "basilisk", Basilisk::LIBPATH )