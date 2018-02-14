 class Object
  def print_time_until_completion(days)
     days = days.ceil
     years = days/365
     days = years >= 1 ? days - (years*365) : days
     months = days/30
     days = months >= 1 ? days  - (months*30) : days
     weeks = days/7
     days = weeks >=1 ? days - (weeks*7) : days
     days_left = days
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
     elsif weeks >1
         str << " #{weeks} weeks"
     end

     if days_left == 1
         str << " 1 day"
     elsif days_left >1
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
 