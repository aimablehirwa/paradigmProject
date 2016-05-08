

class MulticallPhone < Phone
  
  class << self
    def advertiseWaitingCall()
      return proc {"call waiting signal"}
    end
  end
end