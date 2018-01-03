namespace :offers do
  task send_to_users: :environment do
    send_offers_with_balance_condition
    send_offers_with_percentage_complete
    send_offers_with_time_until_completion
  end
end


def send_offers_with_balance_condition
  Offer.where(condition: 'balance').all.each do |offer|
    user_ids_who_havent_been_sent_offer = offer.financial_institution.users.pluck(:id) - offer.messages.pluck(:user_id)
    condition = "balance #{offer.symbol} #{offer.value}"
    user_ids = Goal.select(:user_id).distinct.where(condition).where(user_id: user_ids_who_havent_been_sent_offer).pluck(:user_id)
    user_ids.each do |user_id| 
      offer.messages.create(user_id: user_id)
    end
  end
end


def send_offers_with_percentage_complete
  Offer.where(condition: 'percentage_complete').all.each do |offer|
    user_ids_who_havent_been_sent_offer = offer.financial_institution.users.pluck(:id) - offer.messages.pluck(:user_id)
    condition = "percent_saved #{offer.symbol} #{offer.value}"
    user_ids = Goal.select(:user_id).distinct.joins(:goal_statistic).where(condition).where(user_id: user_ids_who_havent_been_sent_offer).pluck(:user_id)
    user_ids.each do |user_id|
      offer.messages.create(user_id: user_id)
    end
  end
end

def send_offers_with_time_until_completion
  Offer.where(condition: 'percentage_complete').all.each do |offer|
    user_ids_who_havent_been_sent_offer = offer.financial_institution.users.pluck(:id) - offer.messages.pluck(:user_id)
    user_ids = TimeUntilCompletion.select("DISTINCT(user_id)").where("days_until_completion #{offer.symbol} #{offer.value}").where(user_id: user_ids_who_havent_been_sent_offer).pluck(:user_id)
    user_ids.each do |user_id|
      offer.messages.create(user_id: user_id)
    end
  end
end


 