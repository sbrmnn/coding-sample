class AddEnumStatus < ActiveRecord::Migration[5.0]
  def self.up
  	ActiveRecord::Base.connection.execute <<~SQL
      CREATE TYPE status AS ENUM ('successful', 'pending', 'failed');
    SQL
  end

  def self.down
    ActiveRecord::Base.connection.execute <<~SQL
      DROP TYPE status;
    SQL
  end
end
