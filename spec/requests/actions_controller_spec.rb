# frozen_string_literal: true
require 'rails_helper'

describe DiscourseAddNewPostsToSummary::ActionsController do
  let(:user) { Fabricate(:admin) }

  before do
    Jobs.run_immediately!
  end

  context "with new topics" do

    subject { UserNotifications.digest(user) }

    after do
      Discourse.redis.keys('summary-new-users:*').each { |key| Discourse.redis.del(key) }
    end

    let!(:popular_topic) { Fabricate(:topic, user: Fabricate(:coding_horror), created_at: 1.hour.ago) }

    # these are from discourse/spec/mailers/user_notifications_spec.rb
    it "works" do
      SiteSetting.discourse_add_new_posts_to_summary_enabled = true
      expect(subject.to).to eq([user.email])
      expect(subject.subject).to be_present
      expect(subject.from).to eq([SiteSetting.notification_email])
      expect(subject.html_part.body.to_s).to be_present
      expect(subject.text_part.body.to_s).to be_present
      expect(subject.header["List-Unsubscribe"].to_s).to match(/\/email\/unsubscribe\/\h{64}/)
      expect(subject.html_part.body.to_s).to include('New Users')
    end

    it "supports subfolder" do
      SiteSetting.discourse_add_new_posts_to_summary_enabled = true
      set_subfolder "/forum"
      html = subject.html_part.body.to_s
      text = subject.text_part.body.to_s
      expect(html).to be_present
      expect(text).to be_present
      expect(html).to_not include("/forum/forum")
      expect(text).to_not include("/forum/forum")
      expect(subject.header["List-Unsubscribe"].to_s).to match(/http:\/\/test.localhost\/forum\/email\/unsubscribe\/\h{64}/)

      topic_url = "http://test.localhost/forum/t/#{popular_topic.slug}/#{popular_topic.id}"
      expect(html).to include(topic_url)
      expect(text).to include(topic_url)
    end

    # these are for the plugin
    it "includes New Posts" do
      SiteSetting.discourse_add_new_posts_to_summary_enabled = true
      expect(subject.html_part.body.to_s).to include('New Posts')
    end

    it "does not include New Posts if plugin not enabled " do
      SiteSetting.discourse_add_new_posts_to_summary_enabled = false
      expect(subject.html_part.body.to_s).to_not include('New Posts')
    end

    it "matches the original discourse text template" do
      orig_text = File.read('./app/views/user_notifications/digest.text.erb')
      plugin_text_all = (File.read('plugins/discourse-add-new-posts-to-summary/app/views/user_notifications/digest.text.erb'))
      plugin_text_orig = plugin_text_all.lines[3..-1].join
      expect((orig_text == plugin_text_orig)).to be true
    end

    it "matches the original discourse html template" do
      orig_text = File.read('./app/views/user_notifications/digest.html.erb')
      plugin_text_all = (File.read('plugins/discourse-add-new-posts-to-summary/app/views/user_notifications/digest.html.erb'))
      plugin_text_orig = plugin_text_all.lines[3..-1].join
      expect((orig_text == plugin_text_orig)).to be true
    end
  end
end
