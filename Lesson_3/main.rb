require_relative 'train'
require_relative 'train_cargo'
require_relative 'train_pass'
require_relative 'wagon'
require_relative 'wagon_cargo'
require_relative 'wagon_pass'
require_relative 'station'
require_relative 'route'

class App

  def initialize
    @stations = []
    @trains = []
    @routes = []

    seed
    main_menu
  end

  def main_menu

    loop do
      puts 'Какое действие хотите выполнить?'
      puts '__________________________________________________________________________'
      puts ' 1 - Создать станцию'
      puts ' 2 - Создать поезд'
      puts ' 3 - Создать маршрут или управлять станциями маршрута (добавлять, удалять)'
      puts ' 4 - Назначить маршрут поезду'
      puts ' 5 - Добавить вагон к поезду'
      puts ' 6 - Отцепить вагон от поезда'
      puts ' 7 - Перемемтить поезд по маршруту (вперед или назад)'
      puts ' 8 - Посмотреть список станций'
      puts ' 9 - Посмотреть список поездов'
      puts '10 - Посмотреть список поездов на станции'
      puts '11 - Посмотреть список маршрутов'
      puts '12 - Выйти'
      puts '__________________________________________________________________________'

      menu = gets.chomp.to_i

      case
      when menu == 1
        menu_station_add
      when menu == 2
        menu_train_add
      when menu == 3
        menu_route
      when menu == 4
        menu_train_route_assign
      when menu == 5
        menu_train_wagon_add
      when menu == 6
        menu_train_wagon_delete
      when menu == 7
        menu_train_transfer
      when menu == 8
        menu_stations_list
      when menu == 9
        menu_trains_list
      when menu == 10
        menu_station_trains_list
      when menu == 11
        menu_routes_list
      when menu == 12
        break
      end
    end
  end

  private

  def menu_train_add
    puts 'Какой поезд хотите создать?'
    puts ' 1 - Пассажирский'
    puts ' 2 - Грузовой'
    submenu = gets.chomp.to_i

    case
    when submenu == 1
      puts 'Введите номер поезда'
      @trains << PassengerTrain.new(gets.chomp)
    when submenu == 2
      puts 'Введите номер поезда'
      @trains << CargoTrain.new(gets.chomp)
    end
  end

  def menu_station_add
    puts 'Введите название новой станции:'
    Station.new(gets.chomp)
  end

  def menu_route
    puts 'Какое действие хотите выполнить?'
    puts ' 1 - Создать новый маршрут'
    puts ' 2 - Добавить станцию'
    puts ' 3 - Удалить станцию'
    submenu = gets.chomp.to_i
    case
    when submenu == 1
      menu_route_add
    when submenu == 2
      menu_route_station_add
    when submenu == 3
      menu_route_station_delete
    end
  end

  def menu_route_add
    menu_stations_list

    puts 'Введите название начальной станции маршрута:'
    station_start = @stations[gets.chomp.to_i]
    puts 'Введите название конечной станции маршрута:'
    station_end = @stations[gets.chomp.to_i]
    @routes << Route.new(station_start, station_end)
  end

  def menu_route_station_add
    menu_routes_list
    puts 'Укажиете маршрут:'
    route = @routes[gets.chomp.to_i]

    menu_stations_list
    puts 'Укажиете стацию:'
    station = @stations[gets.chomp.to_i]

    if route.exists?(station)
      puts 'Указанная станции уже имеется в маршруте'
    else
      route.add(station)
    end
  end

  def menu_route_station_delete
    menu_routes_list
    puts 'Укажиете маршрут:'
    route = @routes[gets.chomp.to_i]

    puts 'Перечень станций маршрута:'
    stations_list(route.list)
    puts 'Укажиете стацию:'
    station = @stations[gets.chomp.to_i]

    if route.transit?(station)
      route.delete(station)
    else
      puts 'Удаление начальной и конечной станции невозможно'
    end
  end

  def menu_train_route_assign
    menu_trains_list
    puts 'Укажиете поезд:'
    train = @trains[gets.chomp.to_i]

    menu_routes_list
    puts 'Укажиете маршрут:'
    route = @routes[gets.chomp.to_i]

    train.assign_route(route)
  end

  def menu_train_wagon_add
    menu_trains_list
    puts 'Укажиете поезд:'
    train = @trains[gets.chomp.to_i]

    if !train.train_stopped?
      puts 'Прицепка вагонов может осуществляться только если поезд не движется.'
    else
      puts 'Введите номер вагона'
      wagon_number = gets.chomp
      if train.wagon_exists?(wagon_number)
        puts 'Указанный вагон уже прицеплен к поезду'\
      else
        case
        when train.type == 'Пассажирский'
          train.wagon_plus(PassWagon.new(wagon_number))
        when train.type == 'Грузовой'
          train.wagon_plus(CargoWagon.new(wagon_number))
        end
      end
    end
  end

  def menu_train_wagon_delete
    menu_trains_list
    puts 'Укажиете поезд:'
    train = @trains[gets.chomp.to_i]

    i = 0
    train.wagons.each do |wagon|
      puts "#{i} - #{wagon.number} (#{wagon.company_name})"
      i += 1
    end
    puts 'Выберите вагон:'
    wagon = train.wagons[gets.chomp.to_i]


    if train.train_stopped?
      train.wagon_minus(wagon)
    else
      puts 'Отцепка вагонов может осуществляться только если поезд не движется.'
    end

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

  def trains_list (trains)
    i = 0
    trains.each do |train|
      puts "#{i} - #{train.type} поезд: #{train.number} (#{train.company_name})"
      i += 1
    end
  end

  def menu_routes_list
    puts 'Перечень маршрутов:'
    routes_list (@routes)
  end

  def routes_list (routes)
    i = 0
    routes.each do |route|
      puts "#{i} - #{route.list[0].name} - #{route.list[route.list.size-1].name}"
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
    puts 'Укажиете поезд:'
    train = @trains[gets.chomp.to_i]

    puts "Текущая станция: #{train.station_current.name}"
    puts 'Куда переместить поезд:'
    puts '1 - Вперед'
    puts '2 - Назазд'

    submenu = gets.chomp.to_i
    case
    when submenu == 1
      if !train.station_next
        puts 'Поезд находится на конечной станции'
      else
        train.transfer_forward
        puts "Поезд прибыл на станцию: #{train.station_current.name}"
      end
    when submenu == 2
      if !train.station_prev
        puts 'Поезд находится на конечной станции'
      else
        train.transfer_back
        puts "Поезд прибыл на станцию: #{train.station_current.name}"
      end
    end
  end

  def seed
    @stations << Station.new('Москва Казанская')
    @stations << Station.new('Рязань-2')
    @stations << Station.new('Ростов-Главный')
    @stations << Station.new('Топи')
    @stations << Station.new('Симферополь')

    @trains << CargoTrain.new('Поезд Г-1')
    @trains << PassengerTrain.new('Номер П-1')


    @trains[0].company_name = 'Siemens Velaro'
    @trains[1].company_name = 'Maglev'

    @trains[1].speed = 1000

    @routes << Route.new(@stations[0], @stations[4])
    @routes[0].add(@stations[1])
    @routes[0].add(@stations[2])
    @routes[0].add(@stations[3])

    @routes << Route.new(@stations[0], @stations[1])

    @trains[0].assign_route(@routes[0])
    @trains[1].assign_route(@routes[0])

    @trains[0].wagon_plus(CargoWagon.new('Вагон Г-1'))
    @trains[0].wagon_plus(CargoWagon.new('Вагон Г-2'))

    @trains[0].wagons[0].company_name = 'Shinkansen'
    @trains[0].wagons[1].company_name = 'Shinkansen'

    @trains[1].wagon_plus(PassWagon.new('Вагон П-1'))
    @trains[1].wagon_plus(PassWagon.new('Вагон П-2'))
    @trains[1].wagon_plus(PassWagon.new('Вагон П-3'))
  end
end

App.new