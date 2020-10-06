# frozen_string_literal: true

# name: DiscourseAddNewPostsToSummary
# about: Add new posts to summary email
# version: 0.1
# authors: literatecomputing
# url: https://github.com/literatecomputing

register_asset 'stylesheets/common/discourse-add-new-posts-to-summary.scss'
register_asset 'stylesheets/desktop/discourse-add-new-posts-to-summary.scss', :desktop
register_asset 'stylesheets/mobile/discourse-add-new-posts-to-summary.scss', :mobile

enabled_site_setting :discourse_add_new_posts_to_summary_enabled

PLUGIN_NAME ||= 'DiscourseAddNewPostsToSummary'

load File.expand_path('lib/discourse-add-new-posts-to-summary/engine.rb', __dir__)

Rails.configuration.paths['app/views'].unshift(Rails.root.join('plugins', 'discourse-add-new-posts-to-summary', 'app/views'))


after_initialize do
  if enabled_site_setting
  # https://github.com/discourse/discourse/blob/master/lib/plugin/instance.rb
    # see lib/plugin/instance.rb for the methods available in this context

    require_dependency 'user_notifications'
    module ::UserNotificationsOverride
      def digest(user, opts = {})
        since = opts[:since]
        new_posts_count = Post.where("created_at > ?", since).count

        if SiteSetting.discourse_add_new_posts_include_new_post_count
          @post_count = { label_key: 'add_to_summary.digest.new_posts',
          value: new_posts_count,
          href: "#{Discourse.base_url}/new" }
          puts "JP YYY UserNotificationOverride! Since: #{since}. Posts: #{new_posts_count}. PC: #{@post_counts}"
        end
        super(user, opts)
      end
    end

    class ::UserNotifications
      prepend ::UserNotificationsOverride
    end

    module ::DiscourseAddToSummary
      class Engine < ::Rails::Engine
        engine_name PLUGIN_NAME
        #      isolate_namespace DiscourseAddToSummary
      end
    end

  end
end
