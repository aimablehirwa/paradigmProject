module Printing
  ############
  # Printing #
  ############
  
  def printOn
    puts "context >> #{context.printOn} : class >> #{self.adaptedClass} : selector >> #{self.adaptedSelector} : method >> #{self.adaptedImplementation}"
  end
end