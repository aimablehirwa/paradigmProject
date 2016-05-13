

class ScreeningPhone
  
  #################
  # Call handling #
  #################
  
  class << self
    def advertiseWithScreening
      return proc {"#{self.proceed(__method__)} with screening"}
    end
    def proceed(aSelector)
      case aSelector
      when :advertiseWithScreening
        advertiseWithScreening
      else
        return "No advertisement method found."
      end
    end
    
  end
end