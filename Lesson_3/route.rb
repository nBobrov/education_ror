require_relative 'instance_counter'
require_relative 'validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :list

  def initialize(departure, arrival)
    @list = [departure, arrival]
    register_instance
    validate!
  end

  def add(transit)
    exists!(transit)
    @list.insert(-2, transit)
  end

  def exists?(transit)
    exists!(transit)
    true
  rescue
    false
  end

  def delete(transit)
    transit!(transit)
    @list.delete(transit)
  end

  def transit?(transit)
    transit!(transit)
    true
  rescue
    false
  end

  private

  def validate!
    raise ArgumentError, 'Конечная станция маршрута должна отличаться от начальной станции' if list[0].name == list[list.size - 1].name
  end

  def exists!(transit)
    raise ArgumentError, 'Указанная станции уже имеется в маршруте' if list.find { |station| station.name == transit.name }
  end

  def transit!(transit)
    raise ArgumentError, 'Удаление начальной и конечной станции невозможно' unless list.find_index(transit).between?(1, list.size - 2)
  end
end