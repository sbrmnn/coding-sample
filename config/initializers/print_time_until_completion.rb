 class Object
  def print_time_until_completion(days)
     years = days/365
     days_left_yr = days - (years*365)
     months = days_left_yr/30
     days_left_mth = days_left_yr  - (months*30)
     weeks = days_left_mth/7
     days_left_week = days_left_mth - (weeks*7)
     days_left = days_left_week
     str = ""

     if years ==1
       str << "1 year"
     elsif years > 1 
       str << "#{years} years"
     end
     
     if months ==1
       str << " 1 month"
     elsif months > 1
       str << " #{months} months"
     end

     if weeks == 1
         str << " 1 week"
     elsif weeks >=1
         str << " #{weeks} weeks"
     end

     if days_left == 1
         str << " 1 day"
     elsif days_left >=1
         str << " #{days_left} days"
     end
     
     str = str.strip
     
     if str.blank?
         "0 days"
     else
         str
     end
  end
 end
 