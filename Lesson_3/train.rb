class Train
  attr_accessor :speed

  attr_reader :number, :type, :wagons

  def initialize(number)
    @number = number
    @type = initial_type
    @speed = 0
    @wagons = []
  end

  def stop
    @speed = 0
  end

  def wagon_plus(wagon_new)
    if @type != wagon_new.type
      puts 'Тип поезда не соответствует типу вагона. К пассажирскому поезду можно прицепить только пассажирские, к грузовому - грузовые.'
    elsif !train_stopped?
      puts 'Прицепка вагонов может осуществляться только если поезд не движется.'
    elsif @wagons.find { |wagon| wagon.number == wagon_new.number }
      puts 'Указанный вагон уже прицеплен к поезду'
    else
      @wagons << wagon_new
    end
  end

  def wagon_minus(wagon)
    if !train_stopped?
      puts 'Отцепка вагонов может осуществляться только если поезд не движется.'
    else
      @wagons.delete(wagon)
    end
  end

  def assign_route(route)
    @route = route
    @route.list[0].take(self)
    @station_index = 0
  end

  def transfer_forward
    return unless station_next?

    station_current.send(self)
    @station_index += 1
    station_current.take(self)
  end

  def transfer_back
    return unless station_prev?

    station_current.send(self)
    @station_index -= 1
    station_current.take(self)
  end

  def station_current
    @route.list[@station_index]
  end

  def station_next
    @route.list[@station_index + 1] if station_next?
  end

  def station_prev
    @route.list[@station_index - 1] if station_prev?
  end

  def train_stopped?
    @speed.zero?
  end

  def station_next?
    true if @station_index + 1 < @route.list.size
  end

  def station_prev?
    @station_index.positive?
  end
end