Sequel.migration do
  up do
    alter_table :auth_methods do
      set_column_type :provider_name, 'varchar(255)'
    end
  end
end
