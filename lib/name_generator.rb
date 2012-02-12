module NameGenerator
  def createNames(number_of_prefixes, type_of_prefix)
    greek_letters = ["Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega"]
    position = Integer(number_of_prefixes) - 1
    
    if type_of_prefix == "Greek"
      division_names = greek_letters[0..position]
      return division_names
    end
  end
  
  
end