require 'active_cash/version'
require_relative 'active_cash/cache'

module ActiveCash
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def caches(type, opts = {})
      #add exception when another cache exists
      #add metaprogramming to eliminate had codes
      #add procs/lambdas for better finds
      raise 'Unknown cache type' unless type.to_sym == :existence
      @cache_opts = {}
      @cache_opts[:type] = type.to_sym
      @cache_opts[:find_by] = opts[:find_by]
      @cache_opts[:return] = opts[:return]
      @cache_opts[:class] = 'Like'


      self.set_callback :destroy, :before do
        Cache.reset(:exists?, args: { #fix that
          user_id: self.user_id, video_id: self.video_id
        })
      end
    end


    def cached_existence_by(user_id:, video_id:) #fix that
      Cache.exists?(
        find_by: {user_id: user_id, video_id: video_id},
        method_name: __method__.to_s.gsub(':', '').gsub('cached_','').gsub('_by',''),
        klass: 'Like'
      )
    end
  end
end
