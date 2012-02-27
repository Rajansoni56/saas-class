def palindrome?(string)
  string.gsub!(/(\W|\b)+/i, "").downcase!
  string == string.reverse
end

palindrome?("A man, a plan, a canal -- Panama")

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

puts count_words "A man, a plan, a canal -- Panama"
puts count_words "Doo bee doo bee doo"

