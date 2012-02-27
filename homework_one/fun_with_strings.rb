def palindrome?(string)
  string.gsub!(/(\W|\b)+/i, "").downcase!
  string == string.reverse
end

def blank?(word)
  word.gsub(/\s/i, "") == ""
end

def count_words(string)
  string.split(/\W+/).inject({ }) do |hash, word|
    unless blank?(word)
      hash[word.downcase] ||= 0
      hash[word.downcase]  += 1
    end
    hash
  end
end


