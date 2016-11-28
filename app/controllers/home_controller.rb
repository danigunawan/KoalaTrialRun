class HomeController < ApplicationController
  def index
    if @project.present?
      @details = koala_api(@project.oauth_token).get_connections('me', 'accounts')
    end
  end

  def clear_session
    @project.update_attributes!(oauth_token: nil)
    session[:project_id] = nil
    session[:access_token] = nil
    redirect_to root_url
  end

  def callback_facebook
    session['access_token'] = @oauth.get_access_token(params[:code])
    graph = koala_api(session['access_token'])
    details = graph.get_object('me', fields: ['email'])
    details['oauth_token'] = session['access_token']
    proj = Project.from_omniauth(details, current_user)
    session[:project_id] = proj.id
		redirect_to root_url
  end
end
