puts "Как тебя зовут?"
name = gets.chomp

puts "Какой у тебя рост?"
growth = gets.chomp.to_i

weight = (growth - 110) * 1.15

hello_user = name + ", привет!"

if weight > 0
  puts "#{hello_user} Ваш идеальный вес #{weight} кг."
else
  puts "#{hello_user} Ваш вес уже оптимальный."
end