class PassWagon < Wagon
  attr_reader :seats_num, :available_seats_num, :occupied_seats_num

  INITIAL_TYPE = 'Пассажирский'.freeze

  def initialize(number, seats_num)
    super(number)
    @seats_num = seats_num
    @available_seats_num = seats_num
    @occupied_seats_num = 0
    start_validation!
  end

  def take_seat
    return unless available_seats_num?

    @available_seats_num -= 1
    @occupied_seats_num += 1
  end

  def available_seats_num?
    @available_seats_num.positive?
  end

  private

  SEATS_FORMAT = /^[1-9][0-9]*$/.freeze

  attr_writer :available_seats_num, :occupied_seats_num

  def start_validation!
    super
    self.class.validate :seats_num, :presence
    self.class.validate :seats_num, :format, SEATS_FORMAT
    self.class.validate :seats_num, :type, Integer
    validate!
  end
end
