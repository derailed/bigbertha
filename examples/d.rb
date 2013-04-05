require 'firewater'

ref = Firewater::Firebase.new( 'https://firewater-test.firebaseio.com' )
ref.clean
data = {
  a: {
    a_1: %s(Hello World),    
    a_2: 10.5    
  },
  b: {
    b_1: 10,
    b_2: true
  }
}
ref.set( data )