class CargoWagon < Wagon
  attr_reader :capacity, :available_capacity, :occupied_capacity

  def initialize(number, capacity)
    super(number)
    @capacity = capacity
    @available_capacity = capacity
    @occupied_capacity = 0
    validate!
  end

  def load_capacity(value)
    return unless available_capacity?(value)

    @available_capacity -= value
    @occupied_capacity += value
  end

  def available_capacity?(value)
    @available_capacity >= value
  end

  private

  INITIAL_TYPE = 'Грузовой'.freeze
  CAPACITY_FORMAT = /^[1-9][0-9]*$/.freeze

  attr_writer :available_capacity, :occupied_capacity

  def validate!
    super
    raise ArgumentError, 'Неверный объем. Необходимо указать положительное число' if capacity.to_s !~ CAPACITY_FORMAT
  end
end