require 'values'

class Map
  Event = Value.new( :event_type, :ref )
  def diff(other)
    res = dup.
      delete_if { |k, v| other[k] == v }.
      merge!(other.dup.delete_if { |k, v| has_key?(k) })
    events = []  
    res.each_pair do |k,v|
      if self[k]
        if other[k]
          events << Event.new( Bigbertha::Load.evt_value, k ) 
        else
          events << Event.new( Bigbertha::Load.evt_child_removed, k )
        end
      else
        events << Event.new( Bigbertha::Load.evt_child_added, k )
      end
    end
    events
  end  
end