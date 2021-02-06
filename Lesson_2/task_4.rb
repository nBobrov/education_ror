vowels_arr = ['a', 'e', 'i', 'o', 'u']
num = 0
hash = {}

for symbol in 'a'..'z'
  num += 1
  hash[num] = symbol if vowels_arr.include? symbol
end

puts hash