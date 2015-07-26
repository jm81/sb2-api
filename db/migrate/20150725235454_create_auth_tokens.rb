Sequel.migration do
  change do
    create_table :auth_tokens do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :restrict, on_update: :cascade
      foreign_key :auth_method_id, :auth_methods, on_delete: :restrict,
        on_update: :cascade
      DateTime :created_at, null: false
      DateTime :last_used_at, null: false
    end
  end
end
