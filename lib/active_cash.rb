require 'active_cash/version'
require_relative 'active_cash/adapter'
require_relative 'active_cash/cache'
require_relative 'active_cash/utils'

module ActiveCash
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def caches(type, opts = {})
      #add metaprogramming to eliminate hard codes
      #add procs/lambdas for better finds
      raise 'Unknown cache type' unless type.to_sym == :existence
      @cache_opts ||= {}
      name = opts[:name] || opts[:type]
      raise "#{name} cache already exists" unless cache_opts[name].nil?
      @cache_opts[name] = {}
      @cache_opts[name][:name] = name
      @cache_opts[name][:type] = type.to_sym
      @cache_opts[name][:find_by] = opts[:find_by]
      @cache_opts[name][:return] = opts[:return]
      @cache_opts[name][:update_on] = opts[:update_on] || [:create, :update, :destroy]
      @cache_opts[name][:klass] = self.to_s

      Utils.set_callbacks(self, @cache_opts[name])
    end

    def cache_opts
      @cache_opts
    end

    def cached_existence_by(user_id:, video_id:) #fix that
      method_name = __method__.to_s.gsub(':', '').gsub('cached_','').gsub('_by','')

      return Cache.exists?(
        find_by: {user_id: user_id, video_id: video_id},
        method_name: method_name,
        klass: 'Like'
      )
    end
  end
end
