class ReceiptsController < ApplicationController
  include ApplicationHelper
  
  before_action :authenticate_user!
  before_action :authenticate_user_in_airtable
  
  def form
    redirect_to @current_employee["_expenses_form"]
  end
  
  def expense
    flash[:notice] = "Receipt submitted successfully."
    redirect_to root_path
  end

end
