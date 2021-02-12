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
    train = @trains.find { |train| train.number == train_departing.number  }
    @trains.delete(train)
  end

  def trains_search(type_search = '')
    @trains_search = @trains
    @trains_search = @trains.select { |train| train.type == type_search } if type_search != ''
  end
end