class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def take(train_arriving)
    if !@trains.find { |train| train.number == train_arriving.number }
      @trains << train_arriving
    else
      puts 'Указанный поезд уже прибыл на станцию'
    end
  end

  def send(train_departing)
    @trains.delete(train_departing)
  end

  def trains_search(type_search)
    @trains_search = @trains.select { |train| train.type.downcase == type_search.downcase }
  end
end
