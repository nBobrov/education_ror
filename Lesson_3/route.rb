require_relative 'instance_counter'
require_relative 'validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :list

  def initialize(departure, arrival)
    @list = [departure, arrival]
    validate!
    register_instance
  end

  def add(transit)
    @list.insert(-2, transit) unless exists?(transit)
  end

  def exists?(transit)
    true if @list.find { |station| station.name == transit.name }
  end

  def delete(transit)
    @list.delete(transit) if transit?(transit)
  end

  def transit?(transit)
    true if @list.find_index(transit).between?(1, @list.size - 2)
  end

  private

  def validate!
    raise ArgumentError, 'Конечная станция маршрута должна отличаться от начальной станции' if list[0].name == list[list.size - 1].name
  end
end