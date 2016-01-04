module CacheStrategy
  extend self

  def default(model)
    model.send(:caches, :existence, find_by: [:user_id, :video_id])
  end

  def empty(model)
    model.send(:caches, :existence, find_by: [:user_id, :video_id])
  end
end
