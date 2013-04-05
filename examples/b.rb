require 'firewater'

ref = Firewater::Firebase.new( 'https://firewater-test.firebaseio.com' )
ref.clean
ref.set( %w(Hello World) )