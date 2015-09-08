Sequel.migration do
  change do
    alter_table :auth_tokens do
      add_column :closed_at, DateTime
    end
  end
end
