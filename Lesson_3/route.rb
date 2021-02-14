class Route
  attr_reader :list

  def initialize(departure, arrival)
    @list = [departure, arrival]
  end

  def add(transit)
    if !@list.find { |station| station.name == transit.name }
      @list.insert(-2, transit)
    else
      puts 'Указанная станции уже имеется в маршруте'
    end
  end

  def delete(transit)
    if @list.find_index(transit).between?(1, @list.size - 2)
      @list.delete(transit)
    else
      puts 'Удаление начальной и конечной станции невозможно'
    end
  end
end