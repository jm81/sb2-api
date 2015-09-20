Sequel.migration do
  change do
    create_table :profiles do
      primary_key :id
      String :handle
      String :display_name
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :handle, unique: true
    end
  end
end
