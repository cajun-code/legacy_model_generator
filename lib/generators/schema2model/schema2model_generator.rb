class Schema2modelGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  class_option :verbose, :type => :boolean
  class_option :namespace, :type => :boolean, :default => true, :descr => "Wrap modules in Namespace"
  class_option :schema, :type => :string, :default => Rails.env, :required => false, :desc => "Specifies what schema to use for the models"
  argument :namespace_name, :type => :string, :default => "" 
  
  def get_list_of_models
    ActiveRecord::Base.establish_connection(options[:schema].to_sym) if options[:schema] 
    
    @models = ActiveRecord::Base.connection.tables
    @schema = options[:schema]
  end
  
  def create_models
    puts "Number of models #{@models.count} " if options[:verbose]
    puts @models if options[:verbose]
    @models.sort.each do |model_name|
      next if model_name == "schema_migrations"
      @table = Arel::Table.new(model_name.to_sym)
      puts "Generating Class(#{clazz_name}) for #{table_name}" if options[:verbose]
      if options.namespace 
        template "namespace_model.rb", "app/models/#{@namespace_name.downcase}/#{model_name.underscore}.rb"
      else
        template "model.rb", "app/models/#{model_name.underscore}.rb" #, :table_name => model_name
      end
      puts "Completed Generating Class(#{clazz_name}) " if options[:verbose]
    end
  end
  
  def pk?
    !@table.primary_key.blank?
  end
  def pk
    puts "Primary Key: '#{@table.primary_key}'" if options[:verbose]
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
  
  def schema_name
    if(schema_includes_env?)
      @schema.sub(Rails.env, "")
    else
      schema
    end  
  end
  def schema_change?
    @schema != Rails.env
  end
  def schema_includes_env?
    @schema.include?(Rails.env)
  end
end
