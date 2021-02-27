require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@all = []

  def initialize(name)
    @name = name
    @trains = []
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
end
