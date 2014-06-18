require 'logger'

namespace :import do
  desc "Data Importation for all challenges, matches, predictions"
  task :predictions => :environment do |t, args|
    begin
      file = "db/data/predictions.xls"
      p "*************************************************************************************************************"
      p "Importing File : #{file}"
      Spreadsheet.open(file) do |sheet|
        sheet1 = sheet.worksheet 0
        sheet1.each 1 do |row|
          user = User.create_user(row[1], row[2])
          match = Match.by_game_id(row[3]).first
          prediction = user.create_prediction(match, row[11], row[12], row[13], row[14])
        end
      end
      p "****************************************Import Completed*****************************************************"
    rescue Exception => e
      puts "Error while importing #{e} #{e.backtrace}"
    end
  end
  
  desc "Import Data for all matches"
  task :matches => :environment do |t, args|
    begin
      file = "db/data/matches.xls"
      p "*************************************************************************************************************"
      p "Importing File : #{file}"
      Spreadsheet.open(file) do |sheet|
        sheet1 = sheet.worksheet 0
        sheet1.each 1 do |row|
          unless row[0].blank?
            daily_challenge = DailyChallenge.create_daily_challenge(row[1], row[2], row[3])
            p "Created Challenge : #{row[1]}"
            match = daily_challenge.create_match(row[0], row[4], row[5], row[6], row[7], row[8])
            p "Created Match : #{row[4]}"
          end
        end
      end
      p "****************************************Import Completed*****************************************************"
    rescue Exception => e
      puts "Error while importing #{e} #{e.backtrace}"
    end
  end
  
  
end
