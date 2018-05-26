class Timesheet < Airrecord::Table
  Airrecord.api_key = "key0ejSGgrhnyrAvO"
  self.base_key = "appyviJNLk8UPTPiA"
  self.table_name = "Time Sheets"

  belongs_to :job, class: 'Job', column: 'Job'
  belongs_to :employee, class: 'Employee', column: 'Employee'
  
  def self.unprocessed_timesheets
    #self["Time Sheets"].select{|t| t["Time In"].nil?}
    all(filter: "{Time In} = \"\" ")
  end
  
  
end

##t["Time Out"] = Time.now