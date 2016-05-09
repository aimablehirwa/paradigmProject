

class ScreeningPhone
  
  #################
  # Call handling #
  #################
  
  class << self
    def advertiseWithScreening
      return proc {"#{self.proceed(__method__)} with screening"}
    end
    
  end
end