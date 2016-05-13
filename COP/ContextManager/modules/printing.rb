module Printing
  ############
  # Printing #
  ############
  
  def printOn(aStream)
    activeAdaptationCount = self.activeAdaptations.size
    puts "#{self.class.name} #{activeAdaptationCount.asString}"
  end
end