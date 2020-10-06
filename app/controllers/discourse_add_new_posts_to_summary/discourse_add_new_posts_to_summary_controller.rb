# frozen_string_literal: true

module DiscourseAddNewPostsToSummary
  class DiscourseAddNewPostsToSummaryController < ::ApplicationController
    requires_plugin DiscourseAddNewPostsToSummary

    before_action :ensure_logged_in

    def index
    end
  end
end
