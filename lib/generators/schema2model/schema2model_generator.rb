class Schema2modelGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  class_option :namespace, :type => :boolean, :default => true, :description => "Wrap modules in Namespace"
  argument :namespace_name, :type => :string, :default => "" 
  
  def get_list_of_models
    @models = ActiveRecord::Base.connection.tables
  end
  
  def create_models
    @models.sort.each do |model_name|
      next if model_name == "schema_migrations"
      @table = Arel::Table.new(model_name.to_sym)
      if options.namespace 
        template "namespace_model.rb", "app/models/#{@namespace_name.downcase}/#{model_name.underscore}.rb"
      else
        template "model.rb", "app/models/#{model_name.underscore}.rb" #, :table_name => model_name
      end
    end
  end
  
  def pk
    @table.primary_key.name
  end
  def clazz_name
    @table.name.camelcase
  end
  def table_name
    @table.name
  end
  def module_name
    @namespace_name.camelcase
  end
end
