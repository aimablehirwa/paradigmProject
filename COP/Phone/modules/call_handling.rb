module Call_handling
  #################
  # Call handling #
  #################
  
  def answer(aPhoneCall)
    # rendre l'appel actif
    self.activeCall= aPhoneCall
    
    # supprimer l'appel on veut repondre dans la liste des incomingcalls
    # exception si il y en a pas
    if @incomingCalls.delete?(aPhoneCall) == nil
      raise 'Only incoming calls can be answered.'
    end
    # ???? suspendre l'appel
    self.suspend
    
    # ajouter l'appel dans les ongoingcalls
    @ongoingCalls.add?(aPhoneCall)
    
    # ???? recuperer l'appel
    self.resume(aPhoneCall)
  end
  
  def hangUp(aPhoneCall)
    if @ongoingCalls.delete?(aPhoneCall) == nil
      raise 'Only ongoing calls can be hung up.'
    end
    if @activeCall == aPhoneCall
      self.suspend
    end
    @terminatedCalls.add?(aPhoneCall)
  end
  
  # les appels rater sont retire des appels entrant pour etre mis dans les appels rate
  def miss(aPhoneCall)
    if @incomingCalls.delete?(aPhoneCall) == nil
      raise 'Only incoming calls can be missed.'
    end
    @missedCalls.add?(aPhoneCall)
  end
  
  def receive(aPhoneCall)
    @incomingCalls.add?(aPhoneCall)
    Phone.advertise
  end
  
  # recuperation d'un appel suspendu, il doit etre dans le ongoingcalls
  def resume(aPhoneCall)
    if @ongoingCalls.include?(aPhoneCall) == nil
      raise 'Only ongoing calls can be resumed.'
    end
    self.activeCall= aPhoneCall
  end
  
  def suspend()
    self.activeCall= nil
  end
end