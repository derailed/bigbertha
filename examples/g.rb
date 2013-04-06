require 'firewater'

ref = Basilik::Root.new( 'https://firewater-test.firebaseio.com' )
ref.remove
data = {
  a: {
    a_1: %s(Hello World),    
    a_2: {
      a_2_1: 10.5,
      a_2_2: "Word!"
    }   
  },
  b: {
    b_1: 10,
    b_2: true
  }
}
ref.set( data )
ref.child( 'a/a_2/a_2_2' ).read
ref.child( :b ).remove