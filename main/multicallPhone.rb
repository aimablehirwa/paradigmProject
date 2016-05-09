

class MulticallPhone < Phone
  
  #################
  # Call handling #
  #################
  
  class << self
    def advertiseWaitingCall()
      return proc {"call waiting signal"}
    end
  end
  
end