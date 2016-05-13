module Resolution
  ##############
  # Resolution #
  ##############
  
  def ageResolutionPolicy()
    return proc {|adaptation1, adaptation2| self.contextActivationAge(adaptation1.context) <=> self.contextActivationAge(adaptation2.context)}
  end 
  
  def defaultResolutionPolicy()
    return self.singleAdaptationResolutionPolicy
  end
  
  def findNextMethodForClass(aClass, aSymbol, aMethod)
    clone = self.adaptationChainForClass(aClass, aSymbol).clone
    applicableMethods = clone.keep_if{|adaptation| adaptation.adaptedImplementation}
    if(applicableMethods.empty?)
      raise "No applicable methods remain for " + aClass.to_s + ">>" + aSymbol.to_s
    end
    array = applicableMethods.to_a
    
    ind = array.index(aMethod)
    if  array(ind+1) == nil
      raise "The given method is not part of the active chain for " + aClass.to_s + ">>" + aSymbol.to_s
    else 
      return array(ind+1)
    end
    #TODO a supprimer
  end
  
  #def noResolutionPolicy()
  #  adaptation1 = ContextAdaptation.new
  #  adaptation2 = ContextAdaptation.new
  #  return raise "Behaviour adaptations are disallowed by policy"
  #end
  
  #to check
  def singleAdaptationResolutionPolicy()
    proc {|adaptation1, adaptation2|
      if(adaptation1.context == Context.default)
         #proc {false}
         1
      else
        if (adaptation2.context == Context.default)
           #proc {true}
           -1
        else 
           #raise "Conflicting adaptations for " + adaptation1.adaptedClass.to_s + ">>" + adaptation2.adaptedSelector.to_s
           0
        end     
      end
    }    
  end
   
end