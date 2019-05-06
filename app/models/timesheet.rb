class Timesheet < Airrecord::Table
  Airrecord.api_key = ENV["AIRTABLE_APIKEY"]
  # self.base_key = "appyviJNLk8UPTPiA"
  self.table_name = "Time Sheets"

  belongs_to :job, class: 'Job', column: 'Job'
  belongs_to :employee, class: 'Employee', column: 'Employee'
  
  def self.msg
    "this is the message"
  end
  
  def self.current_timesheet employee, user_config
    begin
      self.base_key = user_config.base_id
      employee["Time Sheets"].find{|t| t["Time Out"].nil?}
    rescue StandardError => e
      logger = Logger.new(STDOUT)
      logger.error e
      nil
    end
  end
  
  def self._find record_id, user_config
    self.base_key = user_config.base_id
    Timesheet.find(record_id)
  end
  
end