require_dependency "discourse_add_new_posts_to_summary_constraint"

DiscourseAddNewPostsToSummary::Engine.routes.draw do
  get "/" => "discourse_add_new_posts_to_summary#index", constraints: DiscourseAddNewPostsToSummaryConstraint.new
  get "/actions" => "actions#index", constraints: DiscourseAddNewPostsToSummaryConstraint.new
  get "/actions/:id" => "actions#show", constraints: DiscourseAddNewPostsToSummaryConstraint.new
end
