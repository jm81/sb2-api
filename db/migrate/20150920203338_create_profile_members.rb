Sequel.migration do
  change do
    create_table :profile_members do
      primary_key :id
      foreign_key :profile_id, :profiles, null: false,
        on_delete: :cascade, on_update: :cascade
      foreign_key :member_profile_id, :profiles, null: true,
        on_delete: :cascade, on_update: :cascade
      foreign_key :member_user_id, :users, null: true,
        on_delete: :cascade, on_update: :cascade
      foreign_key :added_by_id, :profiles, null: true,
        on_delete: :cascade, on_update: :cascade

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
