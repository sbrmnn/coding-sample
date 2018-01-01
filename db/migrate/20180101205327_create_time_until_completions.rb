class CreateTimeUntilCompletions < ActiveRecord::Migration[5.0]
  def change
    create_view :time_until_completions
  end
end
