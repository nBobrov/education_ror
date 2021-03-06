require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  NUMBER_FORMAT = /^[a-zа-я\d]{3}-?[a-zа-я\d]{2}$/i

  attr_accessor :speed

  attr_reader :number, :type, :wagons

  class << self
    def find(number)
      Train.all.select { |train| train.number.downcase == number.downcase }
    end
  end

  def initialize(number)

    @number = number
    @type = self.class::INITIAL_TYPE
    @speed = 0
    @wagons = []
    @company_name = Manufacturer::INITIAL_COMPANY_NAME
    validate!
    register_instance
  end

  def stop
    @speed = 0
  end

  def wagon_plus(wagon_new)
    @wagons << wagon_new if train_stopped? && check_type?(wagon_new) && !wagon_exists?(wagon_new.number)
  end

  def wagon_exists?(wagon_new_number)
    true if @wagons.find { |wagon| wagon.number == wagon_new_number }
  end

  def check_type?(wagon)
    true if @type = wagon.type
  end

  def wagon_minus(wagon)
    @wagons.delete(wagon) if train_stopped?
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

  def send_wagon_to_block(&block)
    @wagons.each(&block) if block_given?
  end

  private

  def validate!
    raise ArgumentError, 'Неверный формат номера' if number !~ NUMBER_FORMAT
  end
end