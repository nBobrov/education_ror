class Route
  attr_reader :list

  def initialize(departure, arrival)
    @initial_list = [departure, arrival]
    @list = []

    @list << Station.new(departure)
    @list << Station.new(arrival)
  end

  def add(transit)
    if !@list.find { |station| station.name == transit }
      @list << @list[-1]
      @list[-2] = Station.new(transit)
    else
      puts 'Указанная станции уже имеется в маршруте'
    end
  end

  def delete(transit)
    if @initial_list.include? transit
      puts 'Удаление начальной и конечной станции невозможно'
    else
      station = @list.find { |station| station.name == transit }
      @list.delete(station)
    end
  end
end