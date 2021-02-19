class CargoWagon < Wagon

  private

  def initial_type # private, т.к. метод не должен быть дотсупен из вне
    'Грузовой'
  end
end