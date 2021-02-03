puts("Введите длину 1 стороны:")
side1=gets.chomp.to_i

puts("Введите длину 2 стороны:")
side2=gets.chomp.to_i

puts("Введите длину 3 стороны:")
side3=gets.chomp.to_i

arr = [side1, side2, side3].sort.reverse

if (arr[0]**2==arr[1]**2+arr[2]**2) # например side1=10, side2=6, side3=8
  result="прямоугольный"
elsif (side1==side2 && side1==side3) # например side1=1, side2=1, side3=1
  result="равносторонний"
elsif (side1==side2 || side2==side3 || side3==side1) # например side1=1, side2=1, side3=2
  result="равнобедренный"
else # например side1=1, side2=2, side3=3
  result="неравнобедренний, неравносторонний и непрямоугольный"
end

puts "Треугольник #{result}"