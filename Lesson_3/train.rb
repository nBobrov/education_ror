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
    register_instance
    validate!
  end

  def stop
    @speed = 0
  end

  def wagon_plus(wagon_new)
    wagon_exists!(wagon_new.number)
    check_type!(wagon_new)
    train_stopped!
    @wagons << wagon_new
  end

  def wagon_exists?(wagon_new_number)
    wagon_exists!(wagon_new_number)
    true
  rescue
    false
  end

  def check_type?(wagon)
    check_type!(wagon)
    true
  rescue
    false
  end

  def wagon_minus(wagon)
    train_stopped!
    @wagons.delete(wagon)
  end

  def assign_route(route)
    @route = route
    @route.list[0].take(self)
    @station_index = 0
  end

  def transfer_forward
    station_next!

    station_current.send(self)
    @station_index += 1
    station_current.take(self)
  end

  def transfer_back
    station_prev!

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
    train_stopped!
    true
  rescue
    false
  end

  def station_next?
    true if @station_index + 1 < @route.list.size
  end

  def station_prev?
    @station_index.positive?
  end

  private

  def validate!
    raise ArgumentError, 'Неверный формат номера' if number !~ NUMBER_FORMAT
  end

  def wagon_exists!(wagon_new_number)
    raise ArgumentError, 'Указанный вагон уже прицеплен к поезду' if wagons.find { |wagon| wagon.number == wagon_new_number }
  end

  def check_type!(wagon)
    raise ArgumentError, 'Тип вагона не соответствует типу поезда' if type != wagon.type
  end

  def train_stopped!
    raise ArgumentError, 'Прицепка и отцепка вагонов может осуществляться только если поезд не движется' unless speed.zero?
  end

  def station_next!
    raise ArgumentError, 'Поезд находится на конечной станции' if @station_index + 1 == @route.list.size
  end

  def station_prev!
    raise ArgumentError, 'Поезд находится на конечной станции' if @station_index.zero?
  end
end