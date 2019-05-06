class LocationsController < ApplicationController
  include ApplicationHelper
  
  before_action :authenticate_user!
  
  def location
    if current_user.location
      current_user.location.delete
    end
    current_user.location = Location.create(lat: params[:lat], lng: params[:lng])
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

end
