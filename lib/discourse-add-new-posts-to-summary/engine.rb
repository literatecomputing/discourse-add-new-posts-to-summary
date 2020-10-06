# frozen_string_literal: true
module DiscourseAddNewPostsToSummary
  class Engine < ::Rails::Engine
    engine_name "DiscourseAddNewPostsToSummary".freeze
    isolate_namespace DiscourseAddNewPostsToSummary

    config.after_initialize do
      Discourse::Application.routes.append do
        mount ::DiscourseAddNewPostsToSummary::Engine, at: "/discourse-add-new-posts-to-summary"
      end
    end
  end
end
