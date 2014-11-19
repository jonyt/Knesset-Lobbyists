# Run with sequel -m path/to/migration_dir mysql://yoni:telaviv@localhost/social_coupons_dev
# Foreign key constraints should be added (currently not working, because table is MyISAM, should be InnoDB)
Sequel.migration do
  change do

    create_table(:lobbying_companies) do
      primary_key :id
      String :name, :null => false, :unique => true
      String :corp_id, :unique => true      
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false  
    end

    create_table(:lobbyists) do
      primary_key :id      
      String :name
      Integer :web_id, :unique => true      
      foreign_key(:lobbying_company_id, :lobbying_companies, :key => :id, :on_delete => :cascade, :null => false) 
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false  
    end  
    
    create_table(:companies) do
      primary_key :id
      String :name, :null => false, :unique => true
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false  
    end    

    create_table(:companies_lobbyists) do
      primary_key :id
      foreign_key(:company_id, :companies, :key => :id, :on_delete => :cascade, :null => false) 
      foreign_key(:lobbyist_id, :lobbyists, :key => :id, :on_delete => :cascade, :null => false) 
      DateTime :created_at, :null => false
      DateTime :updated_at, :null => false  
    end        

  end

end