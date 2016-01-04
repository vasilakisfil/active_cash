require 'spec_helper'

describe ActiveCash do
  context 'when like with default update_on ([:create, :udpate, :destroy]) is created' do
    before do
      mock_adapter
      @like = FactoryGirl.create(:default_like)
    end

    adapter("sets to true",
      set_times: 1, set_value: true,
    )

    context 'when trying to fetch the cached value' do
      before do
        remock_adapter
        DefaultLike.cached_existence_by(
          user_id: @like.user_id, video_id: @like.video_id
        )
      end

      adapter("just gets since it exists",
        get_times: 1,
      )

      context 'when deleting the object' do
        before do
          remock_adapter
          DefaultLike.last!.destroy
        end

        adapter("sets to false",
          set_times: 1, set_value: false,
        )

        context 'when recreating the object' do
          before do
            remock_adapter
            @new_like = FactoryGirl.create(:default_like,
              user_id: @like.user_id, video_id: @like.video_id
            )
          end

          adapter("sets to true",
            set_times: 1, set_value: true,
          )
        end
      end
    end
  end
end

describe ActiveCash do
  context 'when like with empty update_on ([]) is created' do
    before do
      mock_adapter
      @like = FactoryGirl.create(:empty_like)
    end

    adapter("sets to true",
      get_times: 1,
    )

    context 'when trying to fetch the cached value' do
      before do
        remock_adapter
        EmptyLike.cached_existence_by(
          user_id: @like.user_id, video_id: @like.video_id
        )
      end

      adapter("just gets since it exists",
        get_times: 1,
        set_times: 1, set_value: true,
      )

      context 'when deleting the object' do
        before do
          remock_adapter
          EmptyLike.last!.destroy
        end

        adapter("sets to false",
          delete_times: 1
        )

        context 'when recreating the object' do
          before do
            remock_adapter
            @new_like = FactoryGirl.create(:empty_like,
              user_id: @like.user_id, video_id: @like.video_id
            )
          end

          adapter("sets to true",
            get_times: 1,
          )
        end
      end
    end
  end
end
