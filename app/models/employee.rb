class Employee < Airrecord::Table
  Airrecord.api_key = "key0ejSGgrhnyrAvO"
  self.base_key = "appyviJNLk8UPTPiA"
  self.table_name = "Employees"
  
  has_many :timesheets, class: 'Timesheet', column: 'Time Sheets'

  def self.current email
    filter_text = format('{Email} = "%s"', email)
    all(filter: filter_text).first
  end
  
  def current_timesheet
    self["Time Sheets"].find{|t| t["Time Out"].nil?}
  end
  
end