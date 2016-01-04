require 'active_cash/version'
require_relative 'active_cash/errors'
require_relative 'active_cash/adapter'
require_relative 'active_cash/cache'
require_relative 'active_cash/utils'

module ActiveCash
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def caches(type, opts = {})
      #add procs/lambdas for better finds
      Utils.raise_unknown_cache_type(type) unless type.to_sym == :existence
      @cache_opts ||= {}
      name = opts[:name] || type.to_sym
      Utils.raise_redefined_cache_error(name) unless cache_opts[name].nil?
      @cache_opts[name] = {}
      @cache_opts[name][:name] = name
      @cache_opts[name][:type] = type.to_sym
      @cache_opts[name][:find_by] = opts[:find_by]
      @cache_opts[name][:return] = opts[:return]
      @cache_opts[name][:update_on] = opts[:update_on] || [:create, :update, :destroy]
      @cache_opts[name][:klass] = self.to_s

      Utils.set_callbacks(self, @cache_opts[name])
      Utils.create_methods(self, @cache_opts[name])
    end

    def cache_opts
      @cache_opts
    end
  end
end
