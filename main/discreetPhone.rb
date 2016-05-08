

class DiscreetPhone < Phone
  
  class << self
    def advertiseDiscreteBeep()
      return proc {"discrete beep"}
    end
  
    def advertiseQuietly()
      return proc {"vibrator"}
    end
  end
end