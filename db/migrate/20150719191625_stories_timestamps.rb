Sequel.migration do
  change do
    alter_table :stories do
      add_column :created_at, DateTime
      add_column :updated_at, DateTime
    end
  end
end
