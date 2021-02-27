require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :list

  def initialize(departure, arrival)
    @list = [departure, arrival]
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

end