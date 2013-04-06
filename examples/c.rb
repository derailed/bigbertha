require 'firewater'

ref = Basilik::Root.new( 'https://firewater-test.firebaseio.com' )
ref.remove
ref.push( "Bumblebee" )
ref.push( "Tuna" )