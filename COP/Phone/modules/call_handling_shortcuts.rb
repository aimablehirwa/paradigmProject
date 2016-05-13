module Call_handling_shortcuts
  ###########################
  # Call handling shortcuts #
  ###########################
  
  # repondre au premier appel dans la file si il y en a un
  def answer()
    _nextCall = @incomingCalls.first
    if _nextCall == nil
      raise 'No incoming calls to answer.' 
    end
    self.answer(_nextCall)
  end
  
  # racrocher un appel si il y a en un qui est actif
  def hangUp()
    if @activeCall == nil
      raise 'No active call to hang up.'
    end
    self.hangUp(@activeCall)
  end 
end