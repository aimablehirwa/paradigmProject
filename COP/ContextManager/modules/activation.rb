module Activation 
  ##############
  # Activation #
  ##############
  
  def contextActivationAge(aContext)
    #return 0 sinon
    return @totalActivations - @activationStamps[aContext]  
  end
  
  #to check
  def signalActivationRequest(aContext)
    @totalActivations = @totalActivations + 1
    @activationStamps[aContext] = @totalActivations
  end
  
  def signalDeactivationRequest(aContext)
    #This callback is invoked whenever a context becomes inactive
  end
end