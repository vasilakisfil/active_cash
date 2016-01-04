module ActiveCash::Utils
  extend self

  def set_callbacks(model, opts)
    if (opts[:update_on] & [:create]).blank?
      model.send(:after_commit, on: [:create]) do
        ActiveCash::Cache.instance_update_if_exists(
          ActiveCash::Utils.extract_instance_args(opts, self)
        )
      end
    else
      model.send(:after_commit, on: [:create]) do
        ActiveCash::Cache.instance_update(
          ActiveCash::Utils.extract_instance_args(opts, self)
        )
      end
    end

    if (opts[:update_on] & [:update]).blank?
      model.send(:after_commit, on: [:update]) do
        if instance_updated?(opts[:find_by], self)
          ActiveCash::Cache.delete(extract_old_instance_args(opts, self))
          ActiveCash::Cache.instance_update_if_exists(
            ActiveCash::Utils.extract_instance_args(opts, self)
          )
        end
      end
    else
      model.send(:after_commit, on: [:update]) do
        if instance_updated?(opts[:find_by], self)
          ActiveCash::Cache.delete(extract_old_instance_args(opts, self))
          ActiveCash::Cache.instance_update(
            ActiveCash::Utils.extract_instance_args(opts, self)
          )
        end
      end
    end

    if (opts[:update_on] & [:destroy]).blank?
      model.send(:after_commit, on: [:destroy]) do
        ActiveCash::Cache.delete(
          ActiveCash::Utils.extract_args(opts, self)
        )
      end
    else
      model.send(:after_commit, on: [:destroy]) do
        ActiveCash::Cache.set_false(
          ActiveCash::Utils.extract_args(opts, self)
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

  #fix this
  def extract_args(opts, instance)
    {
      find_by: opts[:find_by].inject({}){|h, arg|
        h[arg] = instance.send(arg); h
      },
      method_name: opts[:name],
      klass: instance.class.to_s
    }
  end

  #and this
  def extract_instance_args(opts, instance)
    {
      find_by: opts[:find_by].inject({}){|h, arg|
        h[arg] = instance.send(arg); h
      },
      method_name: opts[:name],
      instance: instance
    }
  end

  #and this
  def extract_instance_args(opts, instance)
    {
      find_by: opts[:find_by].inject({}){|h, arg|
        h[arg] = instance.send("#{arg}_was"); h
      },
      method_name: opts[:name],
      instance: instance
    }
  end

  def build_cache_opts(type, opts, cache_opts, klass)
    #add procs/lambdas for better finds
    raise_unknown_cache_type(type) unless type.to_sym == :existence
    cache_opts ||= {}
    name = opts[:name] || type.to_sym
    raise_redefined_cache_error(name) unless cache_opts[name].nil?
    cache_opts[name] = {}
    cache_opts[name][:name] = name
    cache_opts[name][:type] = type.to_sym
    cache_opts[name][:find_by] = opts[:find_by]
    cache_opts[name][:return] = opts[:return]
    cache_opts[name][:update_on] = opts[:update_on] || [:create, :update, :destroy]
    cache_opts[name][:klass] = klass

    return cache_opts
  end
end
