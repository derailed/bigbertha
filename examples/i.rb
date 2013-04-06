require 'bigbertha'

ref = Bigbertha::Load.new( ENV['fb_url'] )
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
a_2_2_ref = ref.child( 'a/a_2/a_2_2' )
a_2_ref   = a_2_2_ref.parent
puts "A_2", a_2_ref.name, a_2_ref.read.inspect
a_ref     = a_2_2_ref.parent.parent
puts "A", a_ref.name, a_ref.read.inspect

a_2_2_ref = ref.child( :a ).child( :a_2 ).child( :a_2_2 )
puts "A_2", a_2_ref.name, a_2_ref.read.inspect