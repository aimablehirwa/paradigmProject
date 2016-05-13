
require 'set'

#Import file
require_relative "modules/accessing.rb"
require_relative "modules/call_handling.rb"
require_relative "modules/call_handling_shortcuts.rb"

#INCLUDE MODULES
include Accessing
include Call_handling
include Call_handling_shortcuts

class Phone
  
  ##################
  # Initialization #
  ##################
  
  def initialize()
    @incomingCalls = SortedSet.new
    @ongoingCalls = SortedSet.new #= OrderedCollection new.
    @terminatedCalls = SortedSet.new#= OrderedCollection new.
    @missedCalls = SortedSet.new#= OrderedCollection new.
  end
  
  ###########################
  # Call handling singleton #
  ########################### 
  class << self
    #default
    def advertise
      return proc {"ringtone"}
    end
    #discreet
    def advertiseDiscreteBeep()
      return proc {"discrete beep"}
    end
    def advertiseQuietly()
      return proc {"vibrator"}
    end
    #screening
    def advertiseWithScreening
      return proc {"#{self.proceed(__method__)} with screening"}
    end
    #multicall
    def advertiseWaitingCall()
      return proc {"call waiting signal"}
    end
    
    def proceed(aSelector)
      case aSelector
      when :advertise
        "ringtone"
      when :advertiseQuitly
        "vibrator"
      when :advertiseDiscreteBeep
        "discrete beep"
      when :advertiWaitingCall
        "call waiting signal"
      else
        return "No advertisement method found."
      end
    end
  end
end