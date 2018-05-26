class TimesheetsController < ApplicationController
  include ApplicationHelper
  
  before_action :authenticate_user!
  before_action :authenticate_user_in_airtable, except: [:home]
  before_action :set_current_timesheet, except: [:home]
  
  def index
    @timesheet_view_url = @current_employee["_time_sheet_view"]
  end
  
  def home
    @current_employee = Employee.current(current_user.email)
    if @current_employee
      @current_timesheet = update_timesheets || @current_timesheet
      @current_job = @current_timesheet.send(:[],"Job")
    else
      @invalid_user = true
    end
  end
  
  def startjob
    end_current_time_sheet
    #get the employee reference and add it to url
    employee_id = @current_employee.id 
    @timesheet_form_url = @current_employee["_time_sheet_form"] + "?prefill_Employee%20Reference=" + employee_id
  end
  
  def endjob
    end_current_time_sheet
    redirect_to root_path
  end
  
  def update_timesheets
    timesheets = Timesheet.unprocessed_timesheets
    employee_id = @current_employee.id
    ct = timesheets.find{|t| t["Time Out"].nil? and t["Employee Reference"] == employee_id}
    if ct
      ct["Time In"] = ct.created_at
      ct["Employee"] = Array(ct["Employee Reference"])
      ct.save
    end
    ct
  end
  
  def set_current_timesheet
    @current_timesheet = @current_employee.current_timesheet
  end
  
  def end_current_time_sheet
    if @current_timesheet
      @current_timesheet["Time Out"] = Time.now
      @current_timesheet.save
    end
  end
end
