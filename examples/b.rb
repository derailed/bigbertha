require 'firewater'

ref = Firewater::Firebase.new( 'https://firewater-test.firebaseio.com' )
ref.remove
ref.set( %w(Hello World) )