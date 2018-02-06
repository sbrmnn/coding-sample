class UpdateTimeUntilCompletionsToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_view :time_until_completions, version: 2, revert_to_version: 1
  end
end
