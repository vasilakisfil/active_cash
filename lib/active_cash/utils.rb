module ActiveCash::Utils
module_function
  def set_callbacks(model, opts)
    (opts[:update_on] & [:destroy]).each do |destroy|
      model.set_callback destroy, :after do
          ActiveCash::Cache.set_false(
            find_by: opts[:find_by].inject({}){|h, arg|
              h[arg] = self.send(arg); h
            },
            method_name: opts[:name],
            klass: opts[:klass]
          )
      end
    end

    (opts[:update_on] & [:create, :update]).each do |callback|
      model.set_callback callback, :after do
          ActiveCash::Cache.instance_update(
            find_by: opts[:find_by].inject({}){|h, arg|
              h[arg] = self.send(arg); h
            },
            method_name: opts[:name],
            instance: self
          )
      end
    end
  end

  def create_methods(model, opts) #raise error when arg not given
    model.send(:define_singleton_method, "cached_#{opts[:name]}_by") do |args = {}|
      return ActiveCash::Cache.exists?(
        find_by: opts[:find_by].inject({}) {|h, arg| h[arg] = args[arg]; h},
        method_name: opts[:name],
        klass: opts[:klass]
      )
    end
  end

  def raise_unknown_cache_type(type)
    raise(
      UnknownCacheTypeError,
      "Unknown cache type #{type}. Valid options are: :existence"
    )
  end

  def raise_redefined_cache_error(name)
    raise(
      RedefinedCacheError,
      "#{name} cache already exists"
    )
  end
end
