Sequel.migration do
  up do
    alter_table :auth_methods do
      rename_column :provider, :provider_name
      add_index [:provider_name, :provider_id], unique: true
    end
  end

  down do
    alter_table :auth_methods do
      rename_column :provider_name, :provider
      add_index [:provider, :provider_id], unique: true
    end
  end
end
