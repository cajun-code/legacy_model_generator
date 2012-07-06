class <%= clazz_name %> < ActiveRecord::Base 
  self.table_name = "<%= table_name %>"
  self.primary_key = "<%= pk %>"
end