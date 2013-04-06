require 'spec_helper'

describe Map do
  describe '#diff' do
    describe 'single vals' do
      it "tracks value changes correctly" do
        prev = Map(:a,1)
        curr = Map(:a,2)
        evts = prev.diff( curr )
        evts.should have(1).item
        evts.first.event_type.should == Basilik::Load.evt_value
        evts.first.ref.should == 'a'
      end    
    
      it "tracks adds correctly" do
        prev = Map.new
        curr = Map(:a,2)
        evts = prev.diff( curr )
        evts.should have(1).item
        evts.first.event_type.should == Basilik::Load.evt_child_added
        evts.first.ref.should == 'a'
      end    
    
      it "tracks deletes correctly" do
        prev = Map(:a,2)
        curr = Map.new
        evts = prev.diff( curr )
        evts.should have(1).item
        evts.first.event_type.should == Basilik::Load.evt_child_removed
        evts.first.ref.should == 'a'
      end
    end
    
    describe 'multi vals' do
      it 'tracks multi value changes correctly' do
        prev = Map(:a,1)
        curr = Map({a:{a_1:10, a_2:20}})
        evts = prev.diff( curr )
        evts.should have(1).item
        evts.first.event_type.should == Basilik::Load.evt_value
        evts.first.ref.should == 'a'
      end
    end
  end
end