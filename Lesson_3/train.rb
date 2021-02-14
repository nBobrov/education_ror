class Train
  attr_accessor :speed

  attr_reader :carriage_count, :number, :type

  def initialize(number, type, carriage_count)
    @number = number
    @type = type
    @carriage_count = carriage_count
    @speed = 0
  end

  def stop
    @speed = 0
  end

  def carriage_count_plus
    if !@speed.zero?
      puts 'Прицепка вагонов может осуществляться только если поезд не движется.'
    else
      @carriage_count += 1
    end
  end

  def carriage_count_minus
    if !@speed.zero?
      puts 'Отцепка вагонов может осуществляться только если поезд не движется.'
    elsif @carriage_count.zero?
      puts "Отцепка невозможна. Количество прицепленных вагонов: #{@carriage_count}."
    else
      @carriage_count -= 1
    end
  end

  def assign_route(route)
    @route = route
    @route.list[0].take(self)
    @station_index = 0
  end

  def transfer_forward
    return unless station_next

    station_current.send(self)
    @station_index += 1
    station_current.take(self)
  end

  def transfer_back
    return unless station_prev

    station_current.send(self)
    @station_index -= 1
    station_current.take(self)
  end

  def station_current
    @route.list[@station_index]
  end

  def station_next
    @route.list[@station_index + 1] if @station_index + 1 < @route.list.size
  end

  def station_prev
    @route.list[@station_index - 1] if @station_index.positive?
  end
end