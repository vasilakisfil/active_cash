require 'active_cash/version'

require 'redis-objects'

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
      name = opts[:name] || type.to_sym
      @cache_opts = Utils.build_cache_opts(type, opts, @cache_opts, self.to_s)
      Utils.set_callbacks(self, @cache_opts[name])
      Utils.create_methods(self, @cache_opts[name])
    end

    def cache_opts
      @cache_opts
    end
  end
end
