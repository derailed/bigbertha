require 'bigbertha'
require 'yaml'

ref = Bigbertha::Load.new( ENV['fb_url'] )
ref.remove
a_ref = ref.push( {a:1, b:2} )
b_ref = ref.push( {c:1, d:2} )
a_ref.set_priority( 20 )
b_ref.set_priority( 10 ) 
puts "A", a_ref.parent.read.to_yaml