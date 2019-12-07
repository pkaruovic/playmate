# frozen_string_literal: true

module JoinRequestHelper
  def render_sorted_join_request_list(join_requests)
    render partial: "join_requests/join_request",
      collection: join_requests.includes(:user)
      .sort_by{ |r| r.user.name },
      cached: true
  end
end
