import { acceptance } from "helpers/qunit-helpers";

acceptance("DiscourseAddNewPostsToSummary", { loggedIn: true });

test("DiscourseAddNewPostsToSummary works", async assert => {
  await visit("/admin/plugins/discourse-add-new-posts-to-summary");

  assert.ok(false, "it shows the DiscourseAddNewPostsToSummary button");
});
