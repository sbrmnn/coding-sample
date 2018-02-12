class UpdateTimeUntilCompletionsToVersion3 < ActiveRecord::Migration[5.0]
  def change
    update_view :time_until_completions, version: 3, revert_to_version: 2
  end
end
