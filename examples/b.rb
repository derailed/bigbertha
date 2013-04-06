require 'bigbertha'

ref = Bigbertha::Load.new( ENV['fb_url'] )
ref.remove
ref.set( %w(Hello World) )