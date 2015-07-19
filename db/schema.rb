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
  end
end
              Sequel.migration do
                change do
                  self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150607204520_create_stories.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150719191625_stories_timestamps.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150719192646_create_users.rb')"
                end
              end
