module ApplicationHelper
  def authenticate_user_in_airtable
    @current_employee = Employee.current(current_user.email)
    unless @current_employee
       redirect_to root_url
    end
  end
end
