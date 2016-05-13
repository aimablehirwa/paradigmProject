require "set"

#Import file
require_relative "modules/accessing.rb"
require_relative "modules/activation.rb"
require_relative "modules/adaptation.rb"
require_relative "modules/life_cycle.rb"
require_relative "modules/printing.rb"
require_relative "modules/resolution.rb"


class ContextManager
  
  #INCLUDE MODULES
  include Accessing
  include Activation
  include Adaptation
  include Life_cycle
  include Printing
  include Resolution
  
  ##################
  # Initialization #
  ##################
  
  def initialize()
    super
    @dictionary = Hash.new(nil)
    @activeAdaptations = Set.new
    @resolutionPolicy = self.defaultResolutionPolicy
    @totalActivations = 0
    @activationStamps = Hash.new(0)
  end
  
  ###########
  # Private #
  ###########
  private
  def activeAdaptations=(aCollection)
    @activeAdaptations = aCollection
  end
  private
  def dictionary=(aDictionary)
    @dictionary = aDictionary
  end
end