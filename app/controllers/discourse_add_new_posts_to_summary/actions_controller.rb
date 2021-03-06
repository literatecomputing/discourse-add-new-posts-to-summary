# frozen_string_literal: true
module DiscourseAddNewPostsToSummary
  class ActionsController < ::ApplicationController
    requires_plugin DiscourseAddNewPostsToSummary

    before_action :ensure_logged_in

    def index
      render_json_dump({ actions: [] })
    end

    def show
      render_json_dump({ action: { id: params[:id] } })
    end
  end
end
