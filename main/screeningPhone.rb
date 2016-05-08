

class ScreeningPhone
  
  class << self
    def advertiseWithScreening(aPhoneCall)
      return proc {"#{thisContext.proceed} with screening"}
    end
  end
end