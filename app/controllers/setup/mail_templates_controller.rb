class Setup::MailTemplatesController < ApplicationController
  before_filter :login_from_cookie
  before_filter :check_login
  before_filter :authorize

  def index
    redirect_to :action => :list
  end

  def list
    @mail_templates = MailTemplate.all
    @page_title = 'Email messages'
  end

  def edit
    logger.debug "MailTemplate:edit"
    @mail_template = MailTemplate.find(params[:id])
    @page_title = "Edit #{@mail_template.name} message"
  end

  def update
    @mail_template = MailTemplate.find(params[:id])

    if @mail_template.update_attributes(params[:mail_template])
      flash[:notice] = 'MailTemplate was successfully updated.'
    else
      flash[:notice] = 'MailTemplate update failed'
    end
    redirect_to :action => :list
  end

end
