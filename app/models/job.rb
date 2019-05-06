class Job < Airrecord::Table
  Airrecord.api_key = ENV["AIRTABLE_APIKEY"]
  self.table_name = "Jobs"

  has_many :timesheets, class: 'Timesheet', column: 'Time Sheets'
  
  def self.from_timesheet timesheet, user_config
    self.base_key = user_config.base_id
    begin
      timesheet['Job']
    rescue
      nil
    end
  end
end