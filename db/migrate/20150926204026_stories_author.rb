Sequel.migration do
  change do
    alter_table :stories do
      add_foreign_key :author_id, :profiles,
        on_delete: :restrict, on_update: :cascade
    end
  end
end
