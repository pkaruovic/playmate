class PopulateJoinRequests < ActiveRecord::Migration[5.2]
  def up
    execute "INSERT INTO join_requests(post_id, user_id, created_at, updated_at) " +
      "SELECT post_id, user_id, created_at, updated_at FROM posts_users;"
  end

  def down
    execute "DELETE FROM join_requests;"
  end
end
