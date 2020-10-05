class DiscourseAddNewPostsToSummaryConstraint
  def matches?(request)
    SiteSetting.discourse_add_new_posts_to_summary_enabled
  end
end
