module Accessors
  def attr_accessor_with_history(*attr_names)
    attr_names.each do |attr_name|
      add_attr_getter(attr_name)
      add_attr_setter(attr_name)
    end
  end

  def strong_attr_accessor(attr_name, attr_class)
    add_attr_getter(attr_name)
    add_attr_setter_strong(attr_name, attr_class)
  end

  private

  def add_attr_getter(attr_name)
    self.class.class_eval do
      define_method(attr_name) { instance_variable_get("@#{attr_name}") }
    end
  end

  def add_attr_setter(attr_name)
    attr_name_history = "#{attr_name}_history"
    instance_variable_set("@#{attr_name_history}", [])

    self.class.class_eval do
      define_method("#{attr_name}=") do |value|
        instance_variable_get("@#{attr_name_history}").push(value)

        instance_variable_set("@#{attr_name}", value)
      end

      define_method(attr_name_history) { instance_variable_get("@#{attr_name_history}") }
    end
  end

  def add_attr_setter_strong(attr_name, attr_class)
    self.class.class_eval do
      define_method("#{attr_name}=") do |value|
        raise ArgumentError, 'Тип переменной отличается от типа присваемого значения!' unless value.instance_of?(attr_class)

        instance_variable_set("@#{attr_name}", value)
      end
    end
  end
end
