require 'firewater'

ref = Firewater::Firebase.new( 'https://firewater-test.firebaseio.com' )
ref.clean
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
ref.child( :a ).update( a_1:"BumbleBee Tuna" )
ref.child( 'a/a_2' ).update( a_2_2:"You bet!" )
ref.child( 'a/a_3' ).update( a_3_1:"You bet!" )