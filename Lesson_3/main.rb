require_relative 'train'
require_relative 'train_cargo'
require_relative 'train_pass'
require_relative 'wagon'
require_relative 'wagon_cargo'
require_relative 'wagon_pass'
require_relative 'station'
require_relative 'route'

class App
  MAIN_MENU = [{ name: 'Управлять станциям', method: 'menu_stations' },
               { name: 'Управлять поездами', method: 'menu_trains' },
               { name: 'Управлять маршрутами', method: 'menu_routes' },
               { name: 'Выйти', method: 'exit' }].freeze
  STATIONS_MENU = [{ name: 'Добавить станцию', method: 'menu_station_add' },
                   { name: 'Посмотреть список станций', method: 'menu_stations_list' },
                   { name: 'Посмотреть список поездов на станции', method: 'menu_station_trains_list' },
                   { name: 'Назад', method: 'exit' }].freeze
  TRAINS_MENU = [{ name: 'Добавить поезд', method: 'menu_train_add' },
                 { name: 'Посмотреть список поездов', method: 'menu_trains_list' },
                 { name: 'Назначить маршрут поезду', method: 'menu_train_route_assign' },
                 { name: 'Посмотреть список вагонов поезда', method: 'menu_wagons_list' },
                 { name: 'Добавить вагон к поезду', method: 'menu_train_wagon_add' },
                 { name: 'Отцепить вагон от поезда', method: 'menu_train_wagon_delete' },
                 { name: 'Переместить поезд по маршруту (вперед или назад)', method: 'menu_train_transfer' },
                 { name: 'Занять место или объем в вагоне', method: 'menu_load_wagon' },
                 { name: 'Назад', method: 'exit' }].freeze
  ROUTES_MENU = [{ name: 'Создать новый маршрут', method: 'menu_route_add' },
                 { name: 'Добавить станцию', method: 'menu_route_station_add' },
                 { name: 'Удалить станцию', method: 'menu_route_station_delete' },
                 { name: 'Посмотреть список маршрутов', method: 'menu_routes_list' },
                 { name: 'Назад', method: 'exit' }].freeze

  def initialize
    @stations = []
    @trains = []
    @routes = []

    seed
    main_menu
  end

  def main_menu
    menu(MAIN_MENU)
  end

  def menu(menu_arr)
    loop do
      menu_item = select_menu_item(menu_arr)

      next unless menu_item
      break if menu_item[:method] == 'exit'

      execute_method(menu_item[:method])
    end
  end

  def select_menu_item(menu_arr)
    puts 'Какое действие хотите выполнить?'
    puts '__________________________________________________________________________'
    menu_arr.each_with_index do |menu_item, index|
      puts "#{index} - #{menu_item[:name]}"
    end
    puts '__________________________________________________________________________'

    menu_arr[gets.chomp.to_i]
  end

  def execute_method(method)
    send(method)
  end

  def menu_stations
    menu(STATIONS_MENU)
  end

  def menu_trains
    menu(TRAINS_MENU)
  end

  def menu_routes
    menu(ROUTES_MENU)
  end

  private

  TRAIN_ADD_MENU = [{ name: 'Добавить пассажирский поезд', method: 'pass_train_add' },
                    { name: 'Добавить грузовой поезд', method: 'cargo_train_add' },
                    { name: 'Назад', method: 'exit' }].freeze

  def menu_train_add
    menu(TRAIN_ADD_MENU)
  rescue ArgumentError => e
    puts e.message
    if retry_input?(retry_counter ||= 0, 3)
      retry_counter = retry_input(retry_counter, 3)
      retry
    end
  end

  def pass_train_add
    puts 'Введите номер поезда в формате XXX-XX или XXXXX, где X-буква латинского или кириллического алфавита, или целое число:'
    @trains << PassengerTrain.new(gets.chomp)
  end

  def cargo_train_add
    puts 'Введите номер поезда в формате XXX-XX или XXXXX, где X-буква латинского или кириллического алфавита, или целое число:'
    @trains << CargoTrain.new(gets.chomp)
  end

  def menu_station_add
    puts 'Введите название новой станции в формате строки:'
    puts 'Минимальная длина строки - 2 символа.'
    puts 'Допустимые символы: буквы латинского и кириллического алфавита, целое число, символ "-" и пробел.'
    @stations << Station.new(gets.chomp)
  rescue ArgumentError => e
    puts e.message
    if retry_input?(retry_counter ||= 0, 3)
      retry_counter = retry_input(retry_counter, 3)
      retry
    end
  end

  def menu_route_add
    menu_stations_list

    station_start = station_select('Укажите начальнцю станцию маршрута:')
    station_end = station_select('Укажите конечную станцию маршрута:')

    @routes << Route.new(station_start, station_end)
  rescue ArgumentError => e
    puts e.message
    if retry_input?(retry_counter ||= 0, 3)
      retry_counter = retry_input(retry_counter, 3)
      retry
    end
  end

  def menu_route_station_add
    menu_routes_list
    route = route_select

    menu_stations_list
    station = station_select

    if route.exists?(station)
      puts 'Указанная станции уже имеется в маршруте'
    else
      route.add(station)
    end
  end

  def route_select
    puts 'Укажиете маршрут:'
    @routes[gets.chomp.to_i]
  end

  def station_select(message = 'Укажиете стацию:')
    puts message
    @stations[gets.chomp.to_i]
  end

  def menu_route_station_delete
    menu_routes_list
    route = route_select

    puts 'Перечень станций маршрута:'
    stations_list(route.list)
    station = station_select

    if route.transit?(station)
      route.delete(station)
    else
      puts 'Удаление начальной и конечной станции невозможно'
    end
  end

  def menu_train_route_assign
    menu_trains_list
    train = train_select

    menu_routes_list
    route = route_select

    train.assign_route(route)
  end

  def menu_train_wagon_add
    menu_trains_list
    train = train_select do |train_check|
      unless train_check.train_stopped?
        puts 'Прицепка вагонов может осуществляться только если поезд не движется.'
        return
      end
      train_check
    end
    train_wagon_add(train) if train
  end

  def train_select
    puts 'Укажиете поезд:'
    train = @trains[gets.chomp.to_i]
    yield(train) if block_given?

    train
  end

  def train_wagon_add(train)
    wagon_number = wagon_select

    if train.wagon_exists?(wagon_number)
      puts 'Указанный вагон уже прицеплен к поезду'
    else
      train_wagon_pass_add(train, wagon_number) if train.type == PassWagon::INITIAL_TYPE
      train_wagon_cargo_add(train, wagon_number) if train.type == CargoWagon::INITIAL_TYPE
    end
  rescue ArgumentError => e
    puts e.message
    if retry_input?(retry_counter ||= 0, 3)
      retry_counter = retry_input(retry_counter, 3)
      retry
    end
  end

  def wagon_select
    puts 'Введите номер вагона в формате XXX-XX, где X-буква латинского или кириллического алфавита, или целое число:'
    gets.chomp
  end

  def train_wagon_pass_add(train, wagon_number)
    puts 'Введите количество мест в вагоне (положительное число):'
    seats_num = gets.chomp.to_i
    train.wagon_plus(PassWagon.new(wagon_number, seats_num))
  end

  def train_wagon_cargo_add(train, wagon_number)
    puts 'Введите объем вагона (положительное число):'
    capacity = gets.chomp.to_i
    train.wagon_plus(CargoWagon.new(wagon_number, capacity))
  end

  def menu_train_wagon_delete
    menu_trains_list
    train = train_select do |train_check|
      unless train_check.train_stopped?
        puts 'Отцепка вагонов может осуществляться только если поезд не движется.'
        return
      end
      train_check
    end

    train_wagon_delete(train) if train
  end

  def menu_wagons_list
    menu_trains_list
    train = train_select

    train_wagon_view(train) if train
  end

  def train_wagon_view(train)
    train.wagons.each_with_index do |wagon, index|
      general_info = "#{index} - #{wagon.type} вагон № #{wagon.number}"
      puts "#{general_info}, свободных мест: #{wagon.available_seats_num}, занятых мест #{wagon.occupied_seats_num}" if wagon.type == PassWagon::INITIAL_TYPE
      puts "#{general_info}, свободный объем: #{wagon.available_capacity}, занятый объем: #{wagon.occupied_capacity}" if wagon.type == CargoWagon::INITIAL_TYPE
    end
  end

  def train_wagon_delete(train)
    train.wagon_minus(train_wagon_select(train))
  end

  def train_wagon_select(train)
    train_wagon_view(train)
    puts 'Выберите вагон:'
    train.wagons[gets.chomp.to_i]
  end

  def menu_stations_list
    puts 'Список станций:'
    stations_list(@stations)
  end

  def stations_list(stations)
    i = 0
    stations.each do |station|
      puts "#{i} - #{station.name}"
      i += 1
    end
  end

  def menu_trains_list
    puts 'Список поездов:'
    trains_list(@trains)
  end

  def trains_list(trains)
    i = 0
    trains.each do |train|
      puts "#{i} - #{train.type} поезд: #{train.number} (#{train.company_name}). Количество вагонов: #{train.wagons.length}"
      i += 1
    end
  end

  def menu_routes_list
    puts 'Перечень маршрутов:'
    routes_list(@routes)
  end

  def routes_list(routes)
    i = 0
    routes.each do |route|
      puts "#{i} - #{route.list[0].name} - #{route.list[route.list.size - 1].name}"
      i += 1
    end
  end

  def menu_station_trains_list
    puts 'Для просмотра списка поездов на станции выберите станцию:'
    menu_stations_list
    station_index = gets.chomp.to_i
    puts "Перечень поездов на станции #{@stations[station_index].name}:"
    trains_list(@stations[station_index].trains)
  end

  def menu_train_transfer
    menu_trains_list
    train = train_select

    puts "Текущая станция: #{train.station_current.name}"
    puts 'Куда переместить поезд:'
    puts '1 - Вперед'
    puts '2 - Назазд'

    submenu = gets.chomp.to_i
    train_transfer_next(train) if submenu == 1
    train_transfer_back(train) if submenu == 2
  end

  def train_transfer_next(train)
    if train.station_next
      train.transfer_forward
      puts "Поезд прибыл на станцию: #{train.station_current.name}"
    else
      puts 'Поезд находится на конечной станции'
    end
  end

  def train_transfer_back(train)
    if train.station_prev
      train.transfer_back
      puts "Поезд прибыл на станцию: #{train.station_current.name}"
    else
      puts 'Поезд находится на конечной станции'
    end
  end

  def menu_load_wagon
    menu_trains_list
    train = train_select do |train_check|
      unless train_check.train_stopped?
        puts 'Загрузка вагонов может осуществляться только если поезд не движется.'
        return
      end
      train_check
    end
    wagon_load(train) if train
  end

  def wagon_load(train)
    wagon = train_wagon_select(train)

    pass_wagon_load(wagon) if train.type == 'Пассажирский'
    cargo_wagon_load(wagon) if train.type == 'Грузовой'
  end

  def pass_wagon_load(wagon)
    if wagon.available_seats_num?
      wagon.take_seat
      puts "Место занято успешно. Свободных мест в вагоне: #{wagon.available_seats_num}"
    else
      puts 'В вагоне недостаточно места'
    end
  end

  def cargo_wagon_load(wagon)
    puts 'Введите объем груза'
    value = gets.chomp.to_i
    if wagon.available_capacity?(value)
      wagon.load_capacity(value)
      puts "Груз загружен успешно. Свободный объем в вагоне: #{wagon.available_capacity}"
    else
      puts 'В вагоне недостаточно места'
    end
  end

  def retry_input(counter, limit)
    puts "Повторите попытку! Попыток осталось: #{limit - counter}"
    counter + 1
  end

  def retry_input?(counter, limit)
    counter < limit
  end

  def seed
    seed_stations
    seed_routes
    seed_trains
    seed_wagons_cargo
    seed_wagons_pass

    @trains[0].speed = 1000
  end
end

def seed_stations
  @stations << Station.new('Москва Казанская')
  @stations << Station.new('Рязань-2')
  @stations << Station.new('Ростов-Главный')
  @stations << Station.new('Топи')
  @stations << Station.new('Симферополь')
end

def seed_trains
  @trains << CargoTrain.new('PPГ-01')
  @trains << PassengerTrain.new('PPП01')

  @trains[0].company_name = 'Siemens Velaro'
  @trains[1].company_name = 'Maglev'

  @trains[0].assign_route(@routes[0])
  @trains[1].assign_route(@routes[0])
end

def seed_routes
  @routes << Route.new(@stations[0], @stations[4])
  @routes[0].add(@stations[1])
  @routes[0].add(@stations[2])
  @routes[0].add(@stations[3])

  @routes << Route.new(@stations[0], @stations[1])
end

def seed_wagons_pass
  @trains[1].wagon_plus(PassWagon.new('VaG-P1', 10))
  @trains[1].wagon_plus(PassWagon.new('VaG-P2', 10))
  @trains[1].wagon_plus(PassWagon.new('Ваг-P1', 5))

  @trains[1].wagons[2].take_seat
  @trains[1].wagons[2].take_seat
end

def seed_wagons_cargo
  @trains[0].wagon_plus(CargoWagon.new('Ваг-Г1', 1000))
  @trains[0].wagon_plus(CargoWagon.new('Ваг-Г2', 5000))

  @trains[0].wagons[0].company_name = 'Shinkansen'
  @trains[0].wagons[1].company_name = 'Shinkansen'
end

App.new
