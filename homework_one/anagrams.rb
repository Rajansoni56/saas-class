def combine_anagram(words)
  words.inject({ }) do |hash, word|
    hash[word.downcase.sum] ||= []
    hash[word.downcase.sum] << word
    hash
  end.values
end

p combine_anagram(['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams', 'scream'])
