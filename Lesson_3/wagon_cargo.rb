class CargoWagon < Wagon
  attr_reader :capacity, :available_capacity, :occupied_capacity

  INITIAL_TYPE = 'Грузовой'.freeze

  def initialize(number, capacity)
    super(number)
    @capacity = capacity
    @available_capacity = capacity
    @occupied_capacity = 0
    start_validation!
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

  CAPACITY_FORMAT = /^[1-9][0-9]*$/.freeze

  attr_writer :available_capacity, :occupied_capacity

  def start_validation!
    super
    self.class.validate :capacity, :presence
    self.class.validate :capacity, :format, CAPACITY_FORMAT
    self.class.validate :capacity, :type, Integer
    validate!
  end
end
