require 'firewater'

ref = Firewater::Firebase.new( 'https://firewater-test.firebaseio.com' )
ref.clean
data = {
  a: 0,
  b: %s(Hello World),
  c: 10.5
}
ref.set( data )