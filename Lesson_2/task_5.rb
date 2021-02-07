months_days = {1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30, 7 => 31, 8 => 31, 9 => 30, 10 => 31, 11 => 30, 12 => 31}

puts "Введите дату в формате dd.mm.yyyy:"
date = gets.chomp.split(".").map(&:to_i)

abort "Указано неверное значение" if date.size != 3

day, month, year = date

abort "Указанная дата не существует (Неверный месяц)" if month > 12


if year.to_f % 4 == 0 && (year.to_f % 100 != 0 || year.to_f % 400 == 0)
  months_days[2] = 29
end

abort "Указанная дата не существует (Неверный день)" if months_days[month] < day

day_count = 0

months_days.each do |month_ref, day_ref|
  if month <= month_ref.to_i
    day_count += day
    abort "Порядковый номер даты: #{day_count}"
  elsif month != month_ref.to_i
    day_count += day_ref.to_i
  end
end