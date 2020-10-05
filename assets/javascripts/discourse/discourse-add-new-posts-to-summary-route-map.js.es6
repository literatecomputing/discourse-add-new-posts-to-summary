export default function() {
  this.route("discourse-add-new-posts-to-summary", function() {
    this.route("actions", function() {
      this.route("show", { path: "/:id" });
    });
  });
};
