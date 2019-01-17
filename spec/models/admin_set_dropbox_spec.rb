# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---
require 'rails_helper'

RSpec.describe AdminSetDropbox, type: :model do
  # describe '#create_dropbox_directory!' do
  #   let(:title) { '' }
  #   let(:admin_set){ described_class.new(title: [title]) }
  #
  #   context 'with clean admin_set title' do
  #     let(:title) { 'african art' }
  #     it 'sets dropbox_directory_name using the admin_set title on admin_set' do
  #       allow(Dir).to receive(:mkdir)
  #       admin_set.send(:create_dropbox_directory!)
  #       expect(admin_set.dropbox_directory_title).to eq(title)
  #     end
  #   end
  #
  #   context 'with disallowed characters in admin_set title' do
  #     let(:title) { '../../secret.rb' }
  #     it 'sanitizes admin_set title for dropbox_directory_name ' do
  #       expect(Dir).to receive(:mkdir).with( File.join(Settings.dropbox.path, '______secret_rb') )
  #       allow(Dir).to receive(:mkdir)
  #       admin_set.send(:create_dropbox_directory!)
  #     end
  #   end
  #
  #   context 'with conflicting/existing dropbox directory' do
  #     let(:title) { 'african art' }
  #     it 'adds a sequence number to the dropbox_directory_name' do
  #       FakeFS.activate!
  #       FileUtils.mkdir_p(File.join(Settings.dropbox.path, title))
  #       FileUtils.mkdir_p(File.join(Settings.dropbox.path, "#{title}_2"))
  #       expect(Dir).to receive(:mkdir).with(File.join(Settings.dropbox.path, "#{title}_3"))
  #       admin_set.send(:create_dropbox_directory!)
  #       FakeFS.deactivate!
  #     end
  #   end
  # end
end
