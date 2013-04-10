require 'bigbertha'

ref = Bigbertha::Ref.new( ENV['fb_url'] )
ref.remove
data = {
  a: 0,
  b: %s(Hello World),
  c: 10.5
}
ref.set( data )