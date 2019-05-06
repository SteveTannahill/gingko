class TimesheetsController < ApplicationController
  include ApplicationHelper
  
  before_action :authenticate_user!
  before_action :authenticate_user_in_airtable, except: [:home]
  before_action :set_current_timesheet, except: [:home]
  
  def index
    
    @timesheet_view_url = @current_employee["_time_sheet_view"]
  end
  
  def home
    @record_id = params[:doc_id]
    @current_employee = Employee.current(current_user.user_config)
    unless @current_employee
      current_user.user_config.try("destroy")
      @current_employee = search_airtable_for_employee
    end
    unless @current_employee 
      @invalid_user = true
    else
      if @record_id
        @current_timesheet = update_timesheets @record_id
      else
        @current_timesheet = set_current_timesheet
      end
    @current_job = @current_timesheet ? Job.from_timesheet(@current_timesheet, @current_user.user_config)  : nil
    end
  end
  
  def startjob
    print "startjob"
    end_current_time_sheet
    print "end of end"
    redirect_to @current_employee["_time_sheet_form"]
  end
  
  def endjob
    end_current_time_sheet
    redirect_to root_path
  end
  
  def endjobmessage
    
    unless @current_timesheet 
      redirect_to root_path
    end
    @current_job = @current_timesheet ? Job.from_timesheet(@current_timesheet, @current_user.user_config)  : nil
  end
  
  def update_timesheets record_id
    @ct = Timesheet._find(record_id, @current_user.user_config)
    employee_id = @current_employee.id
    if @ct
      loc = @current_user.location
      @ct["Time In"] = @ct["created_at"]
      @ct["Employee"] = Array(employee_id)
      if loc
        @ct["Location In"] = Geocoder.search([loc.lat, loc.lng]).try(:first).try(:data).try(:[],"display_name")
      end
      @ct.save
    end
    @ct = Timesheet._find(record_id, @current_user.user_config)
  end
  
  def set_current_timesheet
    @current_timesheet = @current_employee.current_timesheet(@current_user.user_config)
  end
  
  def end_current_time_sheet
    if @current_timesheet
      loc = @current_user.location
      @current_timesheet["Time Out"] = Time.now
      @current_timesheet["Notes"] = params[:notes] || @current_timesheet["Notes"]
      if loc
        @current_timesheet["Location Out"] = Geocoder.search([loc.lat, loc.lng]).try(:first).try(:data).try(:[],"display_name")
      end
      @current_timesheet.save
    end
  end
end
