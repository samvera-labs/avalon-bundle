module Hyrax
  class AvalonAdminSetCreateService < Hyrax::AdminSetCreateService
    # @api public
    # Extends super method to create dropbox directory for the adminset upon creation
    # @param admin_set [AdminSet] the admin set to operate on
    # @param creating_user [User] the user who created the admin set
    # @return [TrueClass, FalseClass] true if it was successful
    # @see AdminSet
    # @raise [RuntimeError] if you attempt to create a default admin set via this mechanism
    def self.call(admin_set:, creating_user:, **kwargs)
      super
      create_dropbox_directory!
    end

    private

    def create_dropbox_directory!
      if Settings.dropbox.path =~ %r(^s3://)
        # do nothing here, s3 case is handled elsewhere
      else
        create_fs_dropbox_directory!
      end
    end

    def create_fs_dropbox_directory!
      name = calculate_dropbox_directory_name do |n|
        File.exist? dropbox_absolute_path(n)
      end

      absolute_path = dropbox_absolute_path(name)

      unless File.directory?(absolute_path)
        begin
          Dir.mkdir(absolute_path)
        rescue Exception => e
          Rails.logger.error "Could not create directory (#{absolute_path}): #{e.inspect}"
        end
      end
      self.dropbox_directory_name = name
    end

    def calculate_dropbox_directory_name
      name = self.dropbox_directory_name

      if name.blank?
        name = Avalon::Sanitizer.sanitize(self.name)
        iter = 2
        original_name = name.dup.freeze
        while yield(name)
          name = "#{original_name}_#{iter}"
          iter += 1
        end
      end
    end
  end
end