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
require 'avalon/dropbox'

describe Avalon::Dropbox do

  describe "#manifests" do
    let(:base_directory) { 'dropbox/TestAdminSet/' }
    let(:admin_set){ AdminSet.new(title: ['TestAdminSet']) }
    let(:dropbox) { described_class.new(base_directory, admin_set)}
    let(:files) { ['manifest.csv', 'manifest.xls', 'test/manifest.xlsx', 'foo.txt'] }

    before do
      FakeFS.activate!
      # FileUtils.touch(files)
      files.collect { |file| FileUtils.touch(File.join(base_directory, file)) }
    end

    after do
      FakeFS.deactivate!
    end

    subject { dropbox.manifests }

    it 'returns all manifests files under the base dreictory' do
      subject.should include(File.join(base_directory, files[0]), File.join(base_directory, files[1]), File.join(base_directory, files[2]))
    end

    it 'does not return any file with invalid file extension' do
      subject.should_not include(File.join(base_directory, files[3]))
    end
  end

end
