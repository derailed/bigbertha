require 'basilisk'

ref = Basilisk::Load.new( ENV['fb_url'] )
ref.remove
ref.push( "Bumblebee" )
ref.push( "Tuna" )