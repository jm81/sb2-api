Sequel.migration do
  change do
    create_table :stories do
      primary_key :id
      foreign_key :parent_id, :stories, on_delete: :restrict,
        on_update: :cascade
      String :body, text: true
      Integer :level, null: false
      Integer :words, null: false
    end
  end
end
