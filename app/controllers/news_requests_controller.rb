class NewsRequestsController < ApplicationController

  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Admin' }

  def index
    @news_requests = NewsRequest.order('created_at desc').includes([:communities]).all
  end

end