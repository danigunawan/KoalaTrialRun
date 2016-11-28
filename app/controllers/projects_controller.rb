class ProjectsController < ApplicationController
  def posts
    user_graph = koala_api(@project.oauth_token)
    page_token = user_graph.get_page_access_token(params[:page_id])
    page_graph = koala_api(page_token)
    posts = page_graph.get_connection('me', 'feed', {fields: ['message', 'id', 'from', 'created_time']})
    @page_id = params[:page_id]
    # @feed_posts = get_posts(posts)
    @feed_posts = []
    posts.each do |post|
      post = page_graph.get_object(post['id'], fields: ['message', 'id', 'from', 'created_time', 'comments', 'likes.summary(true)'])
      new_post = Post.new
      new_post.message = post['message']
      new_post.from = post['from']['name']
      new_post.id = post['id']
      new_post.created_time = post['created_time']
      new_post.has_liked = post['likes']['summary']['has_liked']
      new_post.like_count = post['likes']['summary']['total_count']
      @feed_posts << new_post
    end
    @feed_posts.each do |page_post|
      posts = page_graph.get_object(page_post.id, fields: ['comments{id}'])
      if posts['comments'].present? && posts['comments']['data'].present?
        page_post.comments = []
        posts['comments']['data'].each do |comment_record|
          comment = page_graph.get_object(comment_record['id'], fields: ['message', 'id', 'from', 'created_time', 'likes.summary(true)'])
          new_post = Post.new
          new_post.message = comment['message']
          new_post.from = comment['from']['name']
          new_post.id = comment['id']
          new_post.created_time = comment['created_time']
          new_post.has_liked = comment['likes']['summary']['has_liked']
          new_post.like_count = comment['likes']['summary']['total_count']
          page_post.comments << new_post
        end
      else
        page_post.comments = nil
      end
    end
    @feed_posts.each do |page_post|
      if page_post.comments.present?
        page_post.comments.each do |comment|
          replies = page_graph.get_object(comment.id, fields: ['comments{id}'])
          if replies['comments'].present? && replies['comments']['data'].present?
            comment.comments = []
            replies['comments']['data'].each do |reply_record|
              reply = page_graph.get_object(reply_record['id'], fields: ['message', 'id', 'from', 'created_time','likes.summary(true)'])
              new_post = Post.new
              new_post.message = reply['message']
              new_post.from = reply['from']['name']
              new_post.id = reply['id']
              new_post.created_time = reply['created_time']
              new_post.has_liked = reply['likes']['summary']['has_liked']
              new_post.like_count = reply['likes']['summary']['total_count']
              comment.comments << new_post
            end
          else
            comment.comments = nil
          end
        end
      end
    end
  end

  def update_post
    user_graph = koala_api(@project.oauth_token)
    page_token = user_graph.get_page_access_token(params[:page_id])
    page_graph = koala_api(page_token)

    if params[:like_ids].present?
      params[:like_ids].each do |id|
        post = page_graph.get_object(id, fields: ['likes.summary(true)'])
        if post['likes']['summary']['has_liked']
          page_graph.delete_like(id)
        else
          page_graph.put_like(id)
        end
      end
    end
    page_graph.put_comment(params['comment_post_id'], params['comment_post']) if params["comment_post"].present? && params["comment_post_id"].present?

    redirect_to posts_path(params[:page_id])
  end

  def permissions
    @details = koala_api(@project.oauth_token).get_connections('me', 'permissions')
  end
end
