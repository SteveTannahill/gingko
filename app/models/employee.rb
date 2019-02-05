class Employee < Airrecord::Table
  Airrecord.api_key = ENV["AIRTABLE_APIKEY"]
  
  self.table_name = "Employees"
  
  has_many :timesheets, class: 'Timesheet', column: 'Time Sheets'

  def self.current user_config
    if user_config
      self.base_key = user_config.base_id
      cur = find(user_config.employee_id)
      #check if the record is still current
      #compare emails with case insensitive
      if cur and cur["Status"] == "Active" and cur["Email"].try(:downcase) == user_config.try(:user).try(:email).try(:downcase)
        cur
      else
        nil
      end
    end
  end
  
  def current_timesheet user_config
    if self.fields.find{|k, v| k.eql? "Time Sheets"}
      Timesheet.current_timesheet(self, user_config)
    end
  end
  
end