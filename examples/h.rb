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
a_2_ref = ref.child( 'a/a_2' )
puts "A_2", a_2_ref.read

val = ref.child( :a ).read
puts val.class
puts "A_1", val.a_1, val[:a_1]
puts "A_2", val.a_2, val[:a_2]
