fibonacci_arr = [0, 1]

loop do
  next_num = (fibonacci_arr[-1].to_i + fibonacci_arr[-2].to_i)
  break if next_num > 100
  fibonacci_arr << next_num
end

puts fibonacci_arr