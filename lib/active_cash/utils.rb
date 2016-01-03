module ActiveCash::Utils
  module_function
    def set_callbacks(model, opts)
      (opts[:update_on] & [:destroy]).each do |destroy|
        model.set_callback destroy, :after do
            method_name = :existence
            ActiveCash::Cache.set_false(
              find_by: {user_id: user_id, video_id: video_id},
              method_name: method_name.to_s,
              klass: 'Like'
            )
        end
      end

      (opts[:update_on] & [:create, :update]).each do |callback|
        model.set_callback callback, :after do
            method_name = :existence
            ActiveCash::Cache.instance_update(
              find_by: {user_id: user_id, video_id: video_id},
              method_name: method_name.to_s,
              instance: self
            )
        end
      end
    end
end
