namespace :offers do
  task send_to_users: :environment do
    send_offers_with_balance_condition
    send_offers_with_percentage_complete
    send_offers_with_time_until_completion
  end
end


def send_offers_with_balance_condition
  Offer.where(condition: :balance).all.each do |offer|
    user_ids_who_havent_been_sent_offer = offer.financial_institution.users.pluck(:id) - offer.messages.pluck(:user_id)
    condition = "balance #{offer.symbol} #{offer.value} and xref_goal_type_id=#{offer.xref_goal_type_id}"
    user_ids = Goal.where(condition).where(user_id: user_ids_who_havent_been_sent_offer).pluck(:user_id).uniq
    user_ids.each do |user_id| 
      offer.messages.create(user_id: user_id)
    end
  end
end


def send_offers_with_percentage_complete
  Offer.where(condition: :percentage_complete).all.each do |offer|
    user_ids_who_havent_been_sent_offer = offer.financial_institution.users.pluck(:id) - offer.messages.pluck(:user_id)
    condition = "percent_saved #{offer.symbol} #{offer.value} and goals.xref_goal_type_id = #{offer.xref_goal_type_id}"
    user_ids = Goal.joins(:goal_statistic).where(condition).where(user_id: user_ids_who_havent_been_sent_offer).pluck(:user_id).uniq
    user_ids.each do |user_id|
      offer.messages.create(user_id: user_id)
    end
  end
end

def send_offers_with_time_until_completion
  Offer.where(condition: :time_until_completion).all.each do |offer|
    user_ids_who_havent_been_sent_offer = offer.financial_institution.users.pluck(:id) - offer.messages.pluck(:user_id)
    Goal.where(user_id: user_ids_who_havent_been_sent_offer, xref_goal_type_id: offer.xref_goal_type_id).each do |goal|
      time_until_completion = GoalCompletion.new(goal.id).calculate
      symbol = offer.symbol
      symbol = "==" if symbol == "="
      if (time_until_completion.is_a? Float) && time_until_completion.method("#{symbol}").(offer.value)
        offer.messages.create(user_id: goal.user_id)
      end
    end
  end
end


 