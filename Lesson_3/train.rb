class Train
  attr_accessor :speed

  attr_reader :carriage_count, :station, :number, :type

  def initialize(number, type, carriage_count)
    validation_train(type, carriage_count)

    if @error.empty?
      @number = number
      @type = type
      @carriage_count = carriage_count
      @speed = 0
    else
      puts @error
    end
  end

  def validation_train(type, carriage_count)
    @error = []

    @error << 'Неверное количество вагонов' if carriage_count.to_i.negative? && carriage_count
    @error << 'Неверный тип поезда (допустимые значения: грузовой, пассажирский)' unless %w[грузовой пассажирский].include? type
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
    @station = @route.list[0].name
    @station_index = 0
  end

  def transfer(direction)
    validation_direction(direction)

    if @error.empty?
      @route.list[@station_index].send(self)

      @station_index += 1 if direction == 'вперед'
      @station_index -= 1 if direction == 'назад'

      @station = @route.list[@station_index].name
      @route.list[@station_index].take(self)
    else
      puts @error
    end
  end

  def validation_direction(direction)
    @error = []

    if !%w[вперед назад].include? direction
      @error << 'Неверное направление (допустимые значения: вперед и назад)'
    elsif @station_index.zero? && direction == 'назад'
      @error << 'Перемещение назад невозможно, поезд находится на начальной точке маршрута.'
    elsif @station_index == @route.list.size - 1 && direction == 'вперед'
      @error << 'Перемещение вперед невозможно, поезд находится на конечной точке маршрута.'
    end
  end

  def station_next
     @route.list[@station_index+1].name
  end

  def station_prev
    @route.list[@station_index-1].name
  end

end