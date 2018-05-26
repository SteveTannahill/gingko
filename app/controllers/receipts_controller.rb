class ReceiptsController < ApplicationController
  include ApplicationHelper
  
  before_action :authenticate_user!
  before_action :authenticate_user_in_airtable
  
  def form
    
  end

end
