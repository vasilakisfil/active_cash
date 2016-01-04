require 'spec_helper'

describe DefaultLike do
  context 'when created' do
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

      context 'when updating another object attribute' do
        before do
          remock_adapter
          @created_at = 10.years.ago
          @like.created_at = @created_at
          @like.save!
        end

        it 'updates created_at' do
          expect(DefaultLike.last!.created_at.to_s).to eq @created_at.utc.to_s
        end

        adapter("doesn't update anything",
          get_times: 0,
        )
      end

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

describe EmptyLike do
  context 'when created' do
    before do
      mock_adapter
      @like = FactoryGirl.create(:empty_like)
    end

    adapter("just gets, no set since get failed",
      get_times: 1,
    )

    context 'when trying to fetch the cached value' do
      before do
        remock_adapter
        EmptyLike.cached_existence_by(
          user_id: @like.user_id, video_id: @like.video_id
        )
      end

      adapter("gets and then sets",
        get_times: 1,
        set_times: 1, set_value: true,
      )

      context 'when updating another object attribute' do
        before do
          remock_adapter
          @created_at = 10.years.ago
          @like.created_at = @created_at
          @like.save!
        end

        it 'updates created_at' do
          expect(DefaultLike.last!.created_at.to_s).to eq @created_at.utc.to_s
        end

        adapter("doesn't update anything",
          get_times: 0,
        )
      end

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

          adapter("just gets, no set since get failed",
            get_times: 1,
          )
        end
      end
    end
  end
end

describe DefaultLikeWithReturn do
  context 'when created' do
    before do
      mock_adapter
      @like = FactoryGirl.create(:default_like_with_return)
    end

    adapter("sets to return value",
      set_times: 1, set_value: '@like.foobar',
    )

    context 'when trying to fetch the cached value' do
      before do
        remock_adapter
        DefaultLikeWithReturn.cached_existence_by(
          user_id: @like.user_id, video_id: @like.video_id
        )
      end

      adapter("just gets since it exists",
        get_times: 1,
      )

      context 'when updating another object attribute' do
        before do
          remock_adapter
          @created_at = 10.years.ago
          @like.created_at = @created_at
          @like.save!
        end

        it 'updates created_at' do
          expect(DefaultLikeWithReturn.last!.created_at.to_s).to eq @created_at.utc.to_s
        end

        adapter("doesn't update anything",
          get_times: 0,
        )
      end

      context 'when updating the return object attribute' do
        before do
          remock_adapter
          @new_value = 'foobar'
          @like.foobar = @new_value
          @like.save!
        end

        it 'updates created_at' do
          expect(DefaultLikeWithReturn.last!.foobar.to_s).to eq @new_value
        end

        adapter("doesn't update anything",
          get_times: 0,
          delete_times: 1,
          set_times: 1, set_value: '@new_value'
        )

        it 'returns the updated attributes' do
          expect(DefaultLikeWithReturn.cached_existence_by(
            user_id: DefaultLikeWithReturn.last!.user_id,
            video_id: DefaultLikeWithReturn.last!.video_id
          )).to eq @new_value
        end
      end


      context 'when deleting the object' do
        before do
          remock_adapter
          DefaultLikeWithReturn.last!.destroy
        end

        adapter("sets to false",
          set_times: 1, set_value: false,
        )

        context 'when recreating the object' do
          before do
            remock_adapter
            @new_like = FactoryGirl.create(:default_like_with_return,
              user_id: @like.user_id, video_id: @like.video_id
            )
          end

          adapter("sets to return value",
            set_times: 1, set_value: '@new_like.foobar',
          )
        end
      end
    end
  end
end

describe EmptyLikeWithReturn do
  context 'when created' do
    before do
      mock_adapter
      @like = FactoryGirl.create(:empty_like_with_return)
    end

    adapter("sets to return value",
      get_times: 1#, set_value: '@like.foobar'
    )

    context 'when trying to fetch the cached value' do
      before do
        remock_adapter
        DefaultLikeWithReturn.cached_existence_by(
          user_id: @like.user_id, video_id: @like.video_id
        )
      end

      adapter("just gets since it exists",
        get_times: 1,
      )

      context 'when updating another object attribute' do
        before do
          remock_adapter
          @created_at = 10.years.ago
          @like.created_at = @created_at
          @like.save!
        end

        it 'updates created_at' do
          expect(DefaultLikeWithReturn.last!.created_at.to_s).to eq @created_at.utc.to_s
        end

        adapter("doesn't update anything",
          get_times: 0,
        )
      end

      context 'when deleting the object' do
        before do
          remock_adapter
          DefaultLikeWithReturn.last!.destroy
        end

        adapter("sets to false",
          set_times: 1, set_value: false,
        )

        context 'when recreating the object' do
          before do
            remock_adapter
            @new_like = FactoryGirl.create(:default_like_with_return,
              user_id: @like.user_id, video_id: @like.video_id
            )
          end

          adapter("sets to return value",
            set_times: 1, set_value: '@new_like.foobar',
          )
        end
      end
    end
  end
end
