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
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20150607204520_create_stories.rb')"
  end
end
