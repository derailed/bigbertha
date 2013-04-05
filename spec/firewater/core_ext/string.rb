require 'spec_helper'

describe String do
  describe '#to_val' do
    it "keep strings unchanged" do
      "fred".to_val.should == "fred"
    end
    
    it "converts an integer correctly" do
      "10".to_val.should == 10
    end
    
    it "converts an float correctly" do
      "10.5".to_val.should == 10.5
    end
    
    it "converts a boolean correctly" do
      "true".to_val.should  == true
      "false".to_val.should == false
    end
    
    it 'converts null correctly' do
      'null'.to_val.should == "null"
    end
  end
end