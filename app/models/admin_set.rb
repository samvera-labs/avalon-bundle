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

class AdminSet < ActiveFedora::Base
  property :dropbox_directory_name, predicate: Avalon::RDFVocab::Collection.dropbox_directory_name, multiple: false do |index|
    index.as :stored_sortable
  end

  before_create :create_dropbox_directory!

  def dropbox
    Avalon::Dropbox.new( dropbox_absolute_path, self )
  end

  def dropbox_absolute_path( name = nil )
    File.join(Settings.dropbox.path, name || dropbox_directory_name)
  end

  def create_dropbox_directory!
    if Settings.dropbox.path =~ %r(^s3://)
      create_s3_dropbox_directory!
    else
      create_fs_dropbox_directory!
    end
  end

  private

  def create_s3_dropbox_directory!
    # do nothing for now, s3 case is handled elsewhere

    # base_uri = Addressable::URI.parse(Settings.dropbox.path)
    # name = calculate_dropbox_directory_name do |n|
    #   obj = FileLocator::S3File.new(base_uri.join(n).to_s + '/').object
    #   obj.exists?
    # end
    # absolute_path = base_uri.join(name).to_s + '/'
    # obj = FileLocator::S3File.new(absolute_path).object
    # Aws::S3::Client.new.put_object(bucket: obj.bucket_name, key: obj.key)
    # self.dropbox_directory_name = name
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
      name = Avalon::Sanitizer.sanitize(self.title)
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