require 'bigbertha'

ref = Bigbertha::Ref.new( ENV['fb_url'] )
ref.remove
ref.push( "Bumblebee" )
ref.push( "Tuna" )