class PassWagon < Wagon

  attr_reader :seats_num, :available_seats_num, :occupied_seats_num

  def initialize(number, seats_num)
    super(number)
    @seats_num = seats_num
    @available_seats_num = seats_num
    @occupied_seats_num = 0
    validate!
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

  INITIAL_TYPE = 'Пассажирский'
  SEATS_FORMAT = /^[1-9][0-9]*$/

  attr_writer :available_seats_num, :occupied_seats_num

  def validate!
    super
    raise ArgumentError, 'Неверное количество мест. Необходимо указать положительное число' if seats_num.to_s !~ SEATS_FORMAT
  end
end