require_relative 'manufacturer'
require_relative 'validation'

class Wagon
  include Manufacturer
  include Validation

  NUMBER_FORMAT = /^[a-zа-я\d]{3}-[a-zа-я\d]{2}$/i.freeze

  attr_reader :number, :type

  def initialize(number)
    @number = number
    @type = self.class::INITIAL_TYPE
    @company_name = Manufacturer::INITIAL_COMPANY_NAME
  end

  private

  def start_validation!
    self.class.validate :number, :presence
    self.class.validate :number, :format, NUMBER_FORMAT
    self.class.validate :number, :type, String
  end
end
