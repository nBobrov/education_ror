require_relative 'manufacturer'
require_relative 'validation'

class Wagon
  include Manufacturer
  include Validation

  NUMBER_FORMAT = /^[a-zа-я\d]{3}-[a-zа-я\d]{2}$/i

  attr_reader :number, :type

  def initialize(number)
    @number = number
    @type = self.class::INITIAL_TYPE
    @company_name = Manufacturer::INITIAL_COMPANY_NAME
  end

  private

  def validate!
    raise ArgumentError, 'Неверный формат номера' if number !~ NUMBER_FORMAT
  end
end
