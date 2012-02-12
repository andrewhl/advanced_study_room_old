module SuffixGenerator
  def makeSuffix(number_of_branch, suffix_type)
    roman_ones = ["", "I", "II", "III", "IIII", "V", "VI", "VII", "VIII", "XI"]
    roman_tens = ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"]


    # Params: Number_of_branch, Suffix_Type

    if suffix_type == "Roman Numerals"

      # Roman numerals support up to 100 branches per division
      if number_of_branch < 100
      
        # No tens column
        if number_of_branch < 10
          suffix = roman_ones[Integer(number_of_branch.to_s[-1].chr)]
          return suffix
        # Tens column
        else
          suffix = roman_tens[Integer(number_of_branch.to_s[0].chr)] + roman_ones[Integer(number_of_branch.to_s[-1].chr)]
          return suffix
        end

      elsif number_of_branch == 100
        suffix = "C"
        return suffix
      end

    elsif suffix_type == "Alpha"
    
      # For suffixes with two letters, AA, etc.
      if number_of_branch > 26
        mod = (number_of_branch-1).divmod(26)
        suffix = (mod[0]-1 + 0x41).chr + (mod[1] + 0x41).chr
        return suffix
      # Normal, non-crazy shit
      else
        suffix = (number_of_branch-1 + 0x41).chr
        return suffix
      end

    else
      return number_of_branch
    end

  end
end