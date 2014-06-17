require 'logger'

namespace :import do
  desc "Data Importation for all challenges, matches, predictions"
  task :data => :environment do |t, args|
    begin
      dir_path = "data/*"
      p "*************************************************************************************************************"
      Dir.glob(dir_path).each do |file|
        p "Importing File : #{file}"
        Spreadsheet.open(file) do |sheet|
          sheet1 = sheet.worksheet 0
          sheet1.each 1 do |row|
            user = User.create_user(row[1], row[2])
            daily_challenge = DailyChallenge.create_daily_challenge(row[3], row[4], row[5])
            match = daily_challenge.create_match(row[6], row[7], row[8], row[9], row[10])
            prediction = user.create_prediction(match, row[11], row[12], row[13], row[14])
          end
        end
      end
      p "****************************************Import Completed*****************************************************"
    rescue Exception => e
      puts "Error while importing #{e} #{e.backtrace}"
    end
    
  end
  

  
  
end
