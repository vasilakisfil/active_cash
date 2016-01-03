module ActiveCash::Cache
  module_function
    def exists?(find_by:, method_name:, return: nil, klass:)
      cached = Redis::Value.new(key_name(klass, method_name, find_by))
      return boolean(cached.value) if cached.value

      cached.value = klass.to_s.constantize.exists?(find_by)
    end

    def reset(find_by:, method_name:, return: nil, klass:)
      Redis::Value.new(key_name(klass, method_name, find_by)).delete
    end

    def boolean(value)
      [true, 1, '1', 't', 'T', 'true', 'TRUE'].include? value
    end

    def key_name(klass, method_name, hash_params)
      "#{klass}#{method_name}#{hash_params.values.join('_')}"
    end
end
