class Job < Airrecord::Table
  Airrecord.api_key = "key0ejSGgrhnyrAvO"
  self.base_key = "appyviJNLk8UPTPiA"
  self.table_name = "Jobs"

  has_many :timesheets, class: 'Timesheet', column: 'Time Sheets'
end