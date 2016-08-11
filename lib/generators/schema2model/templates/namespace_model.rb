module <%= module_name %>
  class <%= clazz_name %> < ActiveRecord::Base 
    self.table_name = "<%= table_name %>"
    <% if pk? %>
    self.primary_key = "<%= pk %>"
    <% end %>
    <% if schema_change? %>
    establish_connection "<%= schema_name %><%= '#{Rails.env}' if schema_includes_env? %>".to_sym
    <% end %>

  end
end