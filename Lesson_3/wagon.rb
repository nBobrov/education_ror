require_relative 'manufacturer'

class Wagon
  include Manufacturer

  attr_reader :number, :type

  def initialize(number)
    @number = number
    @type = self.class::INITIAL_TYPE
    @company_name = Manufacturer::INITIAL_COMPANY_NAME
  end
end
