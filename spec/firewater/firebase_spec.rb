require 'spec_helper'

describe Firewater::Firebase do  
  before :all do
    @fb = Firewater::Firebase.new( "https://firewater-test.firebaseio.com" )
  end
    
  describe 'rules' do
    before :each do
      @auth_fb = Firewater::Firebase.new( 
        "https://firewater-test.firebaseio.com",
        '531ufHDrgIBglq058gIj2HPkAFjXRhOD29rO1q79' 
      )
    end
      
    after :each do
      @auth_fb.set_rules( { '.read' => true, '.write' => true } )
    end
    
    it "fetch security rules correctly" do      
      @auth_fb.set( tmp: { a: 0, b: 1 } )
      @auth_fb.set_rules( 
        { '.read' => true, '.write' => false, 
           "tmp"  => { '.read' => true, '.write' => false }
      })
      res= @auth_fb.get_rules
      res.rules.tmp['.read'].should be_true
      res.rules.tmp['.write'].should be_false
      
      res = @fb.child(:tmp).read
      res.should == { a: 0, b: 1 }

      lambda { @fb.set( tmp: { d: 0 } ) }.should raise_error Firewater::Firebase::PermissionDeniedError
    end
  end
  
  describe "#read" do
    before :all do
      @fb.clean
      @fb.set( { 
        test_1: { 
          test_1_1: {
            key_1: 'Hello',
            key_2: 'World'             
           },
           test_1_2: {
             key_1: 10,
             key_2: [10,20,30],
             key_3: {
               test_1_2_1: {
                 key_1: 50
               }                
             }
           }
         },
         test_2: 10,
         test_3: :Blee,
         test_4: %w[hello world],
         test_5: [{a:1,b:2}, {c:3,d:4}]
        }
      )
    end

    it "reads a simple number correctly" do
      @fb.child( :test_2 ).read.to_i.should == 10
    end
    
    it "reads a string correctly" do
      @fb.child( :test_3 ).read.should == "Blee"
    end
    
    it "reads a simple array correctly" do
      @fb.child( :test_4 ).read.should == %w[hello world]
    end    
    
    it "reads an array of hash correctly" do
      @fb.child( 'test_5/0' ).read.a.should == 1
    end   
    
    it "reads a deeply nested hash correctly" do
      @fb.child( 'test_1/test_1_2/key_3').read.test_1_2_1.key_1.should == 50
    end     
  end

  describe '#push' do
    before :each do
      @fb.clean
    end
    
    it "makes up an empty ref if no data" do
      resp = @fb.push()
      resp.name.should_not be_nil
    end
    
    it "builds a list with values" do
      resp = @fb.push( {a:1,b:2} )
      resp.name.should_not be_nil
      @fb.child( resp.name ).read.a.should == 1
      @fb.child( resp.name ).read.b.should == 2
    end
  end
  
  describe 'priority' do
    before :each do
      @fb.clean
    end
    
    it "sets priority with complex data correctly" do
      @fb.set( c:{d:1} )
      ref = @fb.child( :c )
      ref.set_priority( 2.0 )
      ref.get_priority.to_i.should == 2.0
    end

    it "unsets priority correctly" do
      @fb.set( c:{d:1} )
      ref = @fb.child( :c )
      ref.set_priority( 2.0 )
      ref.get_priority.to_i.should == 2.0
      ref.set_priority( nil )
      ref.get_priority.should == nil
    end

    it "sets priority for lists correctly" do
      a_ref = @fb.push( {b:1, a:2} )
      b_ref = @fb.push( {e:1, d:2} )
      a_ref.set_priority( 20 )
      b_ref.set_priority( 10 )      
      a_ref.get_priority.to_i.should == 20
      b_ref.get_priority.to_i.should == 10
      res = a_ref.parent.read
      keys  = [b_ref.name, a_ref.name]
      index = 0
      res.each_pair do |k,v|
        k.should == keys[index]
        index += 1
      end
    end
    
    it "sets priority for lists correctly" do
      a_ref = @fb.push
      a1_ref = a_ref.push( a:1 )
      a2_ref = a_ref.push( b:1 )
      b_ref = @fb.push
      b1_ref = b_ref.push( c:1 )
      b2_ref = b_ref.push( d:1 )
      
      a_ref.set_priority( 20 )
      a1_ref.set_priority( 50 )
      a2_ref.set_priority( 30 )
      b_ref.set_priority( 10 )
      b1_ref.set_priority( 50 )
      b2_ref.set_priority( 30 )      
      
      a1_ref.get_priority.to_i.should == 50
      a2_ref.get_priority.to_i.should == 30
      b1_ref.get_priority.to_i.should == 50
      b2_ref.get_priority.to_i.should == 30
      
      res = a_ref.parent.read
      keys  = [b_ref.name, a_ref.name]
      index = 0
      res.each_pair do |k,v|
        k.should == keys[index]
        index += 1
      end
    end
    
  end
  
  it "reads a simple number correctly" do
    @fb.update( {test_1: 20 } )
    @fb.child( :test_1 ).read.to_i.should == 20
  end
  
  it "adds data correctly" do
    @fb.set( {test_2: { test_3: {test_4: "Hello" } }, fred: 10 } )
    @fb.once :value do |snapshot|
      snapshot.should have(2).items
      snapshot.fred.should == 10
      snapshot.test_2.test_3.test_4.should == "Hello"
    end    
  end
  
  describe '#remove' do
    before :each do
      @fb.clean
    end
    
    it "removes data correctly" do
      @fb.set( {fred: 10} )
      @fb.child( :fred ).remove
      lambda { @fb.child( :fred ).read }.should raise_error( /No data/ )
    end
  end
end