class String
  def to_val
    if self =~ /\A[-+]?\d+$/
      Integer( self )
    elsif self =~ /\A[-+]?\d+\.\d+$/
      Float( self )
    elsif self =~ /false/
      false
    elsif self =~ /true/
      true
    else
      self
    end
  end
end