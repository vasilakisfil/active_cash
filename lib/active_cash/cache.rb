module ActiveCash::Cache
  extend self

  def exists?(find_by:, method_name:, returns:, klass:)
    key_name = get_key_name(klass, method_name, find_by)
    cached_value = adapter.get_value(key_name)
    return cached_value unless cached_value.nil?

    instance = klass.to_s.constantize.find_by(find_by)
    adapter.set_value_with_return(
      key_name, !instance.nil?, instance.try(returns)
    )
  end

  def instance_exists?(find_by:, method_name:, instance:, returns:)
    key_name = get_key_name(instance.class, method_name, find_by)
    cached_value = adapter.get_value(key_name)
    return cached_value unless cached_value.nil?

    instance_update(
      find_by: find_by, method_name: method_name, instance: instance,
      returns: returns
    )
  end

  def instance_update(find_by:, method_name:, returns:, instance:)
    key_name = get_key_name(instance.class, method_name, find_by)

    find_by.keys.each_with_index do |key, i|
      if instance.send(key) != find_by.values[i]
        return adapter.set_value_with_return(key_name, false, returns)
      end
    end

    adapter.set_value_with_return(key_name, true, returns)#instance.try(returns))
  end

  def instance_updated?(find_by:, instance:, returns:)
    changes = OpenStruct.new(instance.previous_changes)
    return true if changes.send(returns) != nil

    find_by.keys.each_with_index do |key, i|
      if changes.send(key) != nil
        return true
      end
    end
  end

  def old_instance_update(find_by:, method_name:, returns:, instance:)
    #old values
    instance_update_if_exists(
      find_by: Hash[find_by.map {|k, v| ["#{k}_was", v] }],
      method_name: method_name,
      returns: returns,
      instance: instance
    )
  end

  def instance_update_if_exists(find_by:, method_name:, returns:, instance:)
    key_name = get_key_name(instance.class, method_name, find_by)

    cached_value = adapter.get_value(key_name)
    return true if cached_value.nil?

    instance_update(
      find_by: find_by, method_name: method_name, instance: instance,
      returns: returns
    )
  end

  def delete(find_by:, method_name:, returns:, klass:)
    key_name = get_key_name(klass, method_name, find_by)
    adapter.delete_value(key_name)
  end

  def set_false(find_by:, method_name:, returns:, klass:)
    key_name = get_key_name(klass, method_name, find_by)
    adapter.set_value_with_return(key_name, false, returns)
  end

  def set_true(find_by:, method_name:, returns:, klass:)
    key_name = get_key_name(klass, method_name, find_by)
    adapter.set_value_with_return(key_name, true, returns)
  end

  def get_key_name(klass, method_name, hash_params)
    "#{klass}:#{method_name}:#{hash_params.values.join('-')}"
  end

  def adapter
    ActiveCash::Adapter
  end
end
