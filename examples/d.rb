require 'basilisk'

ref = Basilisk::Load.new( ENV['fb_url'] )
ref.remove
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