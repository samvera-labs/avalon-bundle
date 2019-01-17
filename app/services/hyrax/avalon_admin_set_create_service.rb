# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
# University. Additional copyright may be held by others, as reflected in
# the commit history.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

require 'avalon/sanitizer'

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
      create_dropbox_directory!(admin_set)
    end

    def self.create_dropbox_directory!(admin_set)
      if Settings.dropbox.path =~ %r{^s3://}
        create_s3_dropbox_directory!(admin_set)
      else
        create_fs_dropbox_directory!(admin_set)
      end
    end

    class << self
      private

      def create_s3_dropbox_directory!(admin_set)
        # do nothing for now, s3 case is handled elsewhere

        # base_uri = Addressable::URI.parse(Settings.dropbox.path)
        # name = calculate_dropbox_directory_name( admin_set ) do |n|
        #   obj = FileLocator::S3File.new(base_uri.join(n).to_s + '/').object
        #   obj.exists?
        # end
        # absolute_path = base_uri.join(name).to_s + '/'
        # obj = FileLocator::S3File.new(absolute_path).object
        # Aws::S3::Client.new.put_object(bucket: obj.bucket_name, key: obj.key)
        # admin_set.dropbox_directory_name = name
      end

      def create_fs_dropbox_directory!(admin_set)
        name = calculate_dropbox_directory_name(admin_set) do |n|
          File.exist? admin_set.dropbox_absolute_path(n)
        end

        absolute_path = admin_set.dropbox_absolute_path(name)

        unless File.directory?(absolute_path)
          begin
            Dir.mkdir(absolute_path)
          rescue SystemCallError => e
            Rails.logger.error "Could not create directory (#{absolute_path}): #{e.inspect}"
          end
        end
        admin_set.dropbox_directory_name = name
      end

      def calculate_dropbox_directory_name(admin_set)
        name = admin_set.dropbox_directory_name

        if name.blank?
          name = Avalon::Sanitizer.sanitize(admin_set.title.first)
          iter = 2
          original_name = name.dup.freeze
          while yield(name)
            name = "#{original_name}_#{iter}"
            iter += 1
          end
        end
        name
      end
    end
  end
end
