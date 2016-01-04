module ActiveCash::Adapter #fix boolean and make it generic
  extend self

  def get_value(key_name)
    value = Redis::Value.new(key_name).value
    is_boolean?(value) ? boolean(value) : value
  end

  def set_value(key_name, value)
    Redis::Value.new(key_name).value = value

    is_boolean?(value) ? boolean(value) : value
  end

  def delete_value(key_name)
    Redis::Value.new(key_name).delete
  end

  def set_value_with_return(key_name, exists, returns)
    if exists
      returns.nil? ? set_value(key_name, true) : set_value(key_name, returns)
    else
      set_value(key_name, false)
    end
  end

  def boolean(value)
    return nil if value.nil?

    [true, 1, '1', 't', 'T', 'true', 'TRUE'].include? value
  end

  def is_boolean?(value)
    [
      true, false, 1, 0, 'true', 'false', '1', '0', 't', 'f', 'TRUE', 'FALSE',
      'T', 'F'
    ].include? value
  end
end
