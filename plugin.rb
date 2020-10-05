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
  # https://github.com/discourse/discourse/blob/master/lib/plugin/instance.rb
    # see lib/plugin/instance.rb for the methods available in this context

    require_dependency 'user_notifications'
    module ::UserNotificationsOverride
      def digest(user, opts = {})
        @add_to_data = {}
        if SiteSetting.discourse_add_to_summary_enabled
          @add_to_data = {}
          base = Discourse.base_url
          base.gsub!(/localhost/,"localhost:3000") # make this work for development
          before_id=SiteSetting.discourse_add_to_summary_before_header_topic_id
          if before_id.to_i > 0
            btopic=Topic.find(before_id)
            before_post_list = Post.where(topic_id: before_id, post_number: btopic.highest_post_number)
            before_text = ""
            if before_post_list.length > 0
              before_text = before_post_list.first.cooked
            end
            before_text.gsub!(/\/\/localhost/,base)
            @add_to_data[:before_text] = before_text
            @add_to_data[:before_css] = SiteSetting.discourse_add_to_summary_before_header_css
            @add_to_data[:before] = before_text.length>0
          end

          after_id=SiteSetting.discourse_add_to_summary_after_header_topic_id
          if after_id.to_i > 0
            atopic=Topic.find(after_id)
            after_post_list = Post.where(topic_id: after_id, post_number: atopic.highest_post_number) unless !atopic
            after_text = ""
            if after_post_list.length > 0
              after_text = after_post_list.first.cooked
            end
            after_text.gsub!(/\/\/localhost/,base)
            @add_to_data[:after_text] = after_text
            @add_to_data[:after_css] = SiteSetting.discourse_add_to_summary_after_header_css
            @add_to_data[:after] = after_text.length>0
          end
        end
        super(user, opts)
      end
    end

    class ::UserNotifications
      prepend ::UserNotificationsOverride
      def self.stupid
        puts "Yes!"
      end

    end

    module ::DiscourseAddToSummary
      class Engine < ::Rails::Engine
        engine_name PLUGIN_NAME
        #      isolate_namespace DiscourseAddToSummary
      end
    end

    module ::PostsOverride
    end


    class ::Posts
      prepend ::PostsOverride
      def self.for_digest(user, since, opts = nil)
        return Post.created_since(since)
      end
    end


    # require_dependency 'user_notifications'
    # class ::UserNotifications
    #   if SiteSetting.discourse_add_to_summary_enabled
    #     prepend AddToMailerExtension
    #   end
    # end

end
