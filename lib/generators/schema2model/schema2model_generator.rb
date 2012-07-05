class Schema2modelGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  def get_list_of_models
    @models = ActiveRecord::Base.connection.tables
  end
  
  def create_models
    @models.each do |model_name|
      @model_name = model_name
      template "model.rb", "app/models/#{model_name.underscore}.rb" #, :table_name => model_name
    end
  end
  
  
end
