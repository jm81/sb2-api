Sequel.migration do
  change do
    create_table :auth_methods do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, on_update: :cascade
      column :provider, 'tinyint unsigned not null'
      column :provider_id, 'integer unsigned not null'
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end

    add_index :auth_methods, [:provider, :provider_id], unique: true
  end
end
