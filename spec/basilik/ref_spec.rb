require 'spec_helper'

describe Basilik::Ref do
  before :all do
    @ref = Basilik::Load.new( ENV['fb_url'] )
  end
  
  describe '#child?' do
    it "retrieves complex values correctly" do
      @ref.set( a:{b:{c:1, d:"hello"}} )
      @ref.child?( :a ).should    == true
      @ref.child?( 'a/b' ).should == true
      @ref.child?( :z ).should    == false
    end
  end

  describe '#children?' do
    it "retrieves complex values correctly" do
      @ref.set( a:{b:{c:1, d:"hello"}} )
      @ref.child(:a).children?.should        == true
      @ref.child('a/b').children?.should     == true
      @ref.child( 'a/b/c' ).children?.should == false
    end
  end

  describe '#num_children' do
    it "retrieves complex values correctly" do
      @ref.set( a:{b:{c:1, d:"hello"}} )
      @ref.child(:a).num_children.should     == 1
      @ref.child('a/b').num_children.should  == 2
      @ref.child( 'a/b/c' ).num_children.should == 0
    end
  end
  
  describe '#val' do
    it "retrieves simple value correctly" do
      @ref.set( a:1 )
      @ref.child( :a ).val.to_i.should == 1
    end
    
    it "retrieves complex values correctly" do
      @ref.set( a:{b:{c:1, d:"hello"}} )
      @ref.child( :a ).val.should == {b:{c:1, d:"hello"}}
    end
  end
  
  describe '#child' do
    it "creates a child ref correctly" do
      child_ref = @ref.child( 'fred')
      child_ref.name.should == 'fred'
      child_ref.parent.to_s.should == ENV['fb_url']
    end
    
    it "creates a deep child ref correctly" do
      child_ref = @ref.child( 'fred/blee/duh')
      child_ref.name.should == 'duh'
      child_ref.parent.to_s.should == ENV['fb_url'] + '/fred/blee'
    end    
  end
  
  describe '#name' do
    it "identifies / as the root name correctly" do
      @ref.name.should be_nil
    end
    
    it "identifies a url name correctly" do
      ref = Basilik::Load.new( ENV['fb_url'] + '/fred/blee' )
      ref.name.should == 'blee'
    end    
  end
  
  describe '#root' do
    it "identifies / as root correctly" do
      @ref.root.should == @ref
    end    

    it "identifies non root url correctly" do
      ref = Basilik::Load.new( ENV['fb_url'] + '/fred/blee' )
      ref.root.to_s.should == ENV['fb_url']
    end        
  end
  
  describe '#root?' do
    it "identifies root correctly" do
      @ref.should be_root
    end
    
    it "identifies / as root correctly" do
      ref = Basilik::Load.new( ENV['fb_url'] + '/' )
      ref.should be_root
    end
    
    it "identifies non root correctly" do
      ref = Basilik::Load.new( ENV['fb_url'] + '/fred' )
      ref.should_not be_root
    end
  end
  
  describe '#parent' do
    it "identifies parent from root correctly" do
      @ref.parent.should be_nil
    end
    
    it "identifies a parent correctly" do
      ref = Basilik::Load.new( ENV['fb_url'] + '/fred/blee' )
      ref.parent.to_s.should == ENV['fb_url'] + '/fred'
    end
  end
end