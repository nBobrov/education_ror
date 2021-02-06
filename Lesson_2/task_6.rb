purchases = Hash[]
total_sum = 0

loop do
  puts "Введите название купленного товара (для завершения введите слово \"стоп\"):"
  name = gets.chomp
  break if (name == "стоп")

  puts "Введите цену товара (#{name}):"
  price = gets.chomp.to_f

  puts "Введите кол-во купленного товара (#{name}):"
  num = gets.chomp.to_i

  purchases[name] =["Цена за еденицу товара" => price, "Количество" => num, "Итоговая сумма" => price*num]
  total_sum += price*num
end

puts purchases
puts "Итоговая сумма всех покупок: #{total_sum}"