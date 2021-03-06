class Setup::IntegrationsController < ApplicationController
  before_filter :login_from_cookie
  before_filter :check_login
  before_filter :authorize

  def edit
    @page_title = 'Edit Payment Gateway Configuration'
    @integration = Integration.first_or_create
  end

  def update
    debug
    @integration = Integration.first
    if params[:name]
      @integration.update_attributes :name => params[:name]
      render :update do |page|
	page.replace_html('integration', :partial => 'integrations')
      end
      return
    else
      if @integration.update_attributes(params[:integration])
	flash[:notice] = 'Update successful'
	debug 'update successful'
      else
	flash[:error] = 'Integration Update failed: ' + @integration.errors.full_messages[0]
	error 'Integration Update failed' + @integration.errors.full_messages[0]
      end
    end
    redirect_to :action => :edit
  rescue => err
    error err
    redirect_to :action => :edit
  end

end
