class Route
  attr_reader :list

  def initialize(departure, arrival)
    @list = []

    @list << departure
    @list << arrival
  end

  def add(transit)
    if !@list.find { |station| station.name == transit.name }
      @list << @list[-1]
      @list[-2] = transit
    else
      puts 'Указанная станции уже имеется в маршруте'
    end
  end

  def delete(transit)
    list_size = @list.size - 1

    @list.each_with_index do |station, index|
      if station.name == transit.name
        if index.zero? || index == list_size
          puts 'Удаление начальной и конечной станции невозможно'
        else
          @list.delete(station)
        end
      end
    end
  end
end