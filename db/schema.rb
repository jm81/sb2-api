Sequel.migration do
  change do
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:stories) do
      primary_key :id
      foreign_key :parent_id, :stories, :on_delete=>:restrict, :on_update=>:cascade
      column :body, "text"
      column :level, "integer", :null=>false
      column :words, "integer", :null=>false
      column :created_at, "timestamp"
      column :updated_at, "timestamp"
    end
    
    create_table(:users) do
      primary_key :id
      column :email, "varchar(255)"
      column :display_name, "varchar(255)"
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp", :null=>false
    end
    
    create_table(:auth_methods) do
      primary_key :id
      foreign_key :user_id, :users, :on_delete=>:cascade, :on_update=>:cascade
      column :provider_name, "tinyint unsigned", :null=>false
      column :provider_id, "integer unsigned", :null=>false
      column :created_at, "timestamp", :null=>false
      column :updated_at, "timestamp", :null=>false
      
      index [:provider_name, :provider_id], :unique=>true
    end
    
    create_table(:auth_tokens) do
      primary_key :id
      foreign_key :user_id, :users, :on_delete=>:restrict, :on_update=>:cascade
      foreign_key :auth_method_id, :auth_methods, :on_delete=>:restrict, :on_update=>:cascade
      column :created_at, "timestamp", :null=>false
      column :last_used_at, "timestamp", :null=>false
    end
  end
end
              Sequel.migration do
                change do
                  self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150607204520_create_stories.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150719191625_stories_timestamps.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150719192646_create_users.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150725205217_create_auth_methods.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150725235454_create_auth_tokens.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150809211350_rename_auth_methods_provider_name.rb')"
                end
              end
