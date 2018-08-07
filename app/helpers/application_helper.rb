module ApplicationHelper
  def authenticate_user_in_airtable
    @current_employee = Employee.current(current_user.user_config)
    unless @current_employee
      current_user.user_config.try("destroy")
      @current_employee = search_airtable_for_employee
    end
    unless @current_employee
      redirect_to root_url
    end
  end
  
  def search_airtable_for_employee
    base_ids = Airrecord.table(ENV["AIRTABLE_APIKEY"], ENV["AIRTABLE_CLIENT_BASE_KEY"], "Config")
    base_ids.all.each do |b| 
      if b["Base ID"]
        employee_id = Airrecord.table(ENV["AIRTABLE_APIKEY"], b["Base ID"], "Employees").all.find{|e| e["Email"] == current_user.email}
        if employee_id 
          current_user.user_config = UserConfig.create(base_id: b["Base ID"], employee_id: employee_id.id)
          return Employee.current(current_user.user_config)
        end
      end
    end
    return nil
  end
end
