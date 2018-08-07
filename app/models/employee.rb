class Employee < Airrecord::Table
  Airrecord.api_key = ENV["AIRTABLE_APIKEY"]
  
  self.table_name = "Employees"
  
  has_many :timesheets, class: 'Timesheet', column: 'Time Sheets'

  def self.current user_config
    if user_config
      self.base_key = user_config.base_id
      find(user_config.employee_id)
    end
  end
  
  def current_timesheet user_config
    if self.fields.find{|k, v| k.eql? "Time Sheets"}
      Timesheet.current_timesheet(self, user_config)
    end
  end
  
end