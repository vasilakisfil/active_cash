class DefaultLike < ActiveRecord::Base
  self.table_name = 'likes'

  include ActiveCash

  caches :existence, find_by: [:user_id, :video_id]
end

class EmptyLike < ActiveRecord::Base
  self.table_name = 'likes'

  include ActiveCash

  caches :existence, find_by: [:user_id, :video_id], update_on: []
end

class DefaultLikeWithReturn < ActiveRecord::Base
  self.table_name = 'likes'

  include ActiveCash

  caches :existence, find_by: [:user_id, :video_id], returns: :foobar
end

class EmptyLikeWithReturn < ActiveRecord::Base
  self.table_name = 'likes'

  include ActiveCash

  caches :existence, find_by: [:user_id, :video_id],
    update_on: [], returns: :foobar
end
