module ActiveCash::Adapter #fix boolean and make it generic
  extend self

  def get_value(key_name)
    boolean(Redis::Value.new(key_name).value)
  end

  def set_value(key_name, value)
    Redis::Value.new(key_name).value = value

    boolean(value)
  end

  def delete_value(key_name)
    Redis::Value.new(key_name).delete
  end

  def boolean(value)
    return nil if value.nil?

    [true, 1, '1', 't', 'T', 'true', 'TRUE'].include? value
  end
end
