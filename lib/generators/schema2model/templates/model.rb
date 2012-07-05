class <%= @model_name.camelcase %> < ActiveRecord::Base 
  self.table_name = "<%= @model_name %>"
end