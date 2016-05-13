

class PhoneCall
  
  #############
  # Accessing #
  #############
  
  def from
    return @from  
  end
  
  def from=(aString)
    @from = aString
  end
  
  ############
  # Printing #
  ############
  
  def printOn(aStream)
    puts "#{self.from}"
  end
  
end
