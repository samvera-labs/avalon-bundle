module Hyrax
  class SlightlyMoreComplexSchemaLoader < SimpleSchemaLoader
    private

      def config_path(schema_name)
        [Rails.root.to_s + "/config/metadata/#{schema_name}.yaml",
        Rails.root.to_s + "/config/metadata/#{schema_name}.yml",
        Hyrax::Engine.root.to_s + "/config/metadata/#{schema_name}.yaml"].find do |path|
          File.exist? path
        end
      end
  end
end