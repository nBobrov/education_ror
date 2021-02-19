class Wagon
  attr_reader :number, :type

  def initialize(number)
    @number = number
    @type = initial_type
  end
end
