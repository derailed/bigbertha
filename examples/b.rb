require 'bigbertha'

ref = Bigbertha::Ref.new( ENV['fb_url'] )
ref.remove
ref.set( %w(Hello World) )