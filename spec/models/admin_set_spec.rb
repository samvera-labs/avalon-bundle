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

RSpec.describe AdminSet, type: :model do
  describe '#create_dropbox_directory!' do
    let(:admin_set){ create(:admin_set) }

    it 'removes bad characters from admin_set name' do
      admin_set.name = '../../secret.rb'
      expect(Dir).to receive(:mkdir).with( File.join(Settings.dropbox.path, '______secret_rb') )
      allow(Dir).to receive(:mkdir) # stubbing this out in a before(:each) block will effect where mkdir is used elsewhere (i.e. factories)
      admin_set.send(:create_dropbox_directory!)
    end
    it 'sets dropbox_directory_name on admin_set' do
      admin_set.title = 'african art'
      allow(Dir).to receive(:mkdir)
      admin_set.send(:create_dropbox_directory!)
      expect(admin_set.dropbox_directory_title).to eq('african_art')
    end
    it 'uses a different directory name if the directory exists' do
      admin_set.title = 'african art'
      FakeFS.activate!
      FileUtils.mkdir_p(File.join(Settings.dropbox.path, 'african_art'))
      FileUtils.mkdir_p(File.join(Settings.dropbox.path, 'african_art_2'))
      expect(Dir).to receive(:mkdir).with(File.join(Settings.dropbox.path, 'african_art_3'))
      admin_set.send(:create_dropbox_directory!)
      FakeFS.deactivate!
    end
  end
end