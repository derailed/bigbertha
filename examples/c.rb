require 'firewater'

ref = Firewater::Firebase.new( 'https://firewater-test.firebaseio.com' )
ref.clean
ref.push( "Bumblebee" )
ref.push( "Tuna" )