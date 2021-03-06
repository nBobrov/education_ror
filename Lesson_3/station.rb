require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  NAME_FORMAT = /^[а-яa-z0-9\-\s]{2,}$/i

  attr_reader :name, :trains

  @@all = []

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    @@all << self
  end

  def self.all
    @@all
  end

  def take(train_arriving)
    @trains << train_arriving unless exists?(train_arriving)
  end

  def exists?(train_arriving)
    true if @trains.find { |train| train.number == train_arriving.number }
  end

  def send(train_departing)
    @trains.delete(train_departing)
  end

  def trains_search(type_search)
    @trains_search = @trains.select { |train| train.type.downcase == type_search.downcase }
  end

  def send_train_to_block(&block)
    @trains.each(&block) if block_given?
  end

  private

  def validate!
    raise ArgumentError, 'Необходимо указать наименование станции' if name.empty?
    raise ArgumentError, 'Это наименование слишком короткое' if name.length < 2
    raise ArgumentError, 'Наименование содержит запрещенные символы. Допустимые символы: буквы кириллического и латинского алфавита, а также пробел и -' if name !~ NAME_FORMAT
  end
end
