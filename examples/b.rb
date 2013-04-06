require 'basilisk'

ref = Basilisk::Load.new( ENV['fb_url'] )
ref.remove
ref.set( %w(Hello World) )