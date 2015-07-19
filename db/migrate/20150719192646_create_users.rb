Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      String :email
      String :display_name
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
