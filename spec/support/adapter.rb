module ActiveCash::TestAdapter #fix boolean and make it generic
  extend self

  def get_value(key_name)
    spy_object.get_value(key_name)

    return ActiveCash::Adapter.get_value(key_name)
  end

  def set_value(key_name, value)
    spy_object.set_value(key_name, value)

    return ActiveCash::Adapter.set_value(key_name, value)
  end

  def delete_value(key_name)
    spy_object.delete_value(key_name)

    return ActiveCash::Adapter.delete_value(key_name)
  end

  def boolean(value) #probably not used
    spy_object.boolean(value)

    return ActiveCash::Adapter.boolean(value)
  end

  def spy_object
  end
end

