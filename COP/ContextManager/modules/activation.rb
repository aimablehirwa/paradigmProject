module Activation 
  ##############
  # Activation #
  ##############
  
  def contextActivationAge(aContext)
    #return 0 sinon
    temp = @activationStamps[aContext]
    if temp == nil
      return @totalActivations - 0
    else
      return @totalActivations - temp
    end
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