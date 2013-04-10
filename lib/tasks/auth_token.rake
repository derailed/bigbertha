namespace :token do
  desc 'Generates firebase auth token'
  task :generate, :secret, :admin do |t, opts|
    opts = opts.with_defaults( admin:true, debug:false, simulate:false )
    gen = Firebase::FirebaseTokenGenerator.new( opts.delete( :secret ) )
    data = {}
    puts "Your auth token\n #{gen.create_token( data, opts ) }"
  end
end