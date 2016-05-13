module Installation
  ################
  # Installation #
  ################
  
  def deploy
   #"Install adapted method implementation.
   #(avoid #basicAddSelector:withMethod:, because it changes the class and selector of the method passed as argument."
    symbol = self.adaptedSelector.to_sym
    Phone.define_singleton_method(symbol, self.adaptedImplementation)    
  end
end