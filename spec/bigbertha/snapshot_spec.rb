require 'spec_helper'
require 'yaml'

describe Bigbertha::Snapshot do
  
  describe '#to_map' do
    it "sorts a simple hierarchy correctly" do
      snap = Bigbertha::Snapshot.new( {a:{b:1} } )
      snap.to_map.a.should == {b:1}
    end
    
    it "sorts a priority hierarchy correctly" do
      snap = Bigbertha::Snapshot.new({
        a: {
          '.priority' => 1000,
          a_1: {
            '.priority' => 20, 
            a_1_1: 1
          },
          a_2: {
            '.priority' => 10, 
            a_2_1: 1
          }           
        },
        b: {
          '.priority' => 0,
          b_1: {
            '.priority' => 50, 
            b_1_1: 1
          },
          b_2: {
            '.priority' => 10, 
            b_2_1: 1
          }
        }        
      })
      map = snap.to_map
      map.keys.should   == %w(b a)
      map.b.keys.should == %w(b_2 b_1)
      map.a.keys.should == %w(a_2 a_1)
    end

    it "sorts a mixed priority hierarchy correctly" do
      snap = Bigbertha::Snapshot.new({
        a: {
          a_1: {
            '.priority' => 20, 
            a_1_1: 1
          },
          a_2: {
            '.priority' => 10, 
            a_2_1: 1
          }           
        },
        b: {
          b_1: {
            '.priority' => "10", 
            b_1_1: 1
          },
          b_2: {
            '.priority' => "10", 
            b_2_1: 1
          }
        }        
      })
      map = snap.to_map
      map.keys.should   == %w(a b)
      map.b.keys.should == %w(b_1 b_2)
      map.a.keys.should == %w(a_2 a_1)
    end
    
    it "sorts a firebase hierarchy correctly" do
      map = Map( JSON.parse( '{
        "-IrIRswPWIABbNj1q045" : {
          ".priority" : 10.0,
          "-IrIRt0-K0Ae0VkYGzPz" : {
            "c" : 1,
            ".priority" : 50.0
          },
          "-IrIRt4bNTVPk7bILOqR" : {
            ".priority" : 30.0,
            "d" : 1
          }
        },
        "-IrIRsiaW32Hp5xUOyMZ" : {
          ".priority" : 20.0,
          "-IrIRsnD1QRcgMU4lgH1" : {
            ".priority" : 50.0,
            "a" : 1
          },
          "-IrIRsrpWvE7ykm4tRBT" : {
            ".priority" : 30.0,
            "b" : 1
          }
        }
      }'))
      snap = Bigbertha::Snapshot.new( map )
      map = snap.to_map
      map.keys.should == %w(-IrIRswPWIABbNj1q045 -IrIRsiaW32Hp5xUOyMZ)
      map['-IrIRsiaW32Hp5xUOyMZ'].keys.should == %w(-IrIRsrpWvE7ykm4tRBT -IrIRsnD1QRcgMU4lgH1)
    end  
    
    it "sorts a complex hierarchy correctly" do
      map = Map( JSON.parse( '{
        "-IrIRswPWIABbNj1q045" : {
          ".priority" : 10.0,
          "-IrIRt0-K0Ae0VkYGzPz" : {
            "c" : 1,
            ".priority" : 50.0
          },
          "-IrIRt4bNTVPk7bILOqR" : {
            ".priority" : 30.0,
            "d" : 1
          }
        },
        "-IrIRsiaW32Hp5xUOyMZ" : {
          "-IrIRsnD1QRcgMU4lgH1" : {
            ".priority" : 50.0,
            "a" : 1
          },
          "-IrIRsrpWvE7ykm4tRBT" : {
            ".priority" : 30.0,
            "b" : 1
          }
        }
      }'))
      snap = Bigbertha::Snapshot.new( map )
      map = snap.to_map
      map.keys.should == %w(-IrIRsiaW32Hp5xUOyMZ -IrIRswPWIABbNj1q045)
      map['-IrIRsiaW32Hp5xUOyMZ'].keys.should == %w(-IrIRsrpWvE7ykm4tRBT -IrIRsnD1QRcgMU4lgH1)
    end  

    it "sorts a complex hierarchy correctly" do
      map = Map( JSON.parse( '{
        "-IrIRswPWIABbNj1q045" : {
          ".priority" : "10.0",
          "-IrIRt0-K0Ae0VkYGzPz" : {
            "c" : 1,
            ".priority" : 50.0
          },
          "-IrIRt4bNTVPk7bILOqR" : {
            ".priority" : 30.0,
            "d" : 1
          }
        },
        "-IrIRsiaW32Hp5xUOyMZ" : {
          ".priority" : 10.0,          
          "-IrIRsnD1QRcgMU4lgH1" : {
            ".priority" : 50.0,
            "a" : 1
          },
          "-IrIRsrpWvE7ykm4tRBT" : {
            ".priority" : 30.0,
            "b" : 1
          }
        },
        "-IrIRsiaW32Hp5xUOyMA" : {
          "-IrIRsnD1QRcgMU4lgH1" : {
            ".priority" : 50.0,
            "a" : 1
          },
          "-IrIRsrpWvE7ykm4tRBT" : {
            ".priority" : 30.0,
            "b" : 1
          }
        }        
      }'))
      snap = Bigbertha::Snapshot.new( map )
      map = snap.to_map
      map.keys.should == %w(-IrIRsiaW32Hp5xUOyMA -IrIRsiaW32Hp5xUOyMZ -IrIRswPWIABbNj1q045)
      map['-IrIRsiaW32Hp5xUOyMZ'].keys.should == %w(-IrIRsrpWvE7ykm4tRBT -IrIRsnD1QRcgMU4lgH1)
    end    
  end
end
