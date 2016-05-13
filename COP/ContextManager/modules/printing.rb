module Printing
  ############
  # Printing #
  ############
  
  def printOn()
    activeAdaptationCount = self.activeAdaptations.size
    puts "#{self.class.name} #{activeAdaptationCount.asString}"
  end
end
