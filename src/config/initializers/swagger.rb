class Swagger::Docs::Config
  def self.transform_path(path, api_version)
  end
end

Swagger::Docs::Config.register_apis({
  '1.0' => {
    controller_base_path: '',
    api_file_path: 'public',
    base_path: '/',
    clean_directory: true,
    api_extension_type: nil,
    attributes: {
      info: {
        title: 'API Documentation',
        description: 'Documentation and API explorer'
      }
    }
  }
})
