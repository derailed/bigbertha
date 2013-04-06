require 'firewater'

ref = Basilik::Root.new( 'https://firewater-test.firebaseio.com' )
ref.remove
data = {
  a: 0,
  b: %s(Hello World),
  c: 10.5
}
ref.set( data )