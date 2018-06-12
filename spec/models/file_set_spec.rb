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

require 'rails_helper'

RSpec.describe FileSet do
  describe '#structure', clean_repo: true do
    let(:file_set) { described_class.create }

    context 'when a structure file is present' do
      before do
        structure = file_set.build_structure
        structure.content = 'structure'
      end
      subject { file_set.structure }
      it 'can be saved without errors' do
        expect(subject.save).to be_truthy
      end
      it 'retrieves content of the structure' do
        expect(subject.content).to eql 'structure'
      end
      it 'retains origin pcdm.File RDF type' do
        expect(subject.metadata_node.type).to include(Hydra::PCDM::Vocab::PCDMTerms.File)
      end
      it 'has use type of IntermediateFile' do
        expect(subject.metadata_node.type).to include(::RDF::URI('http://pcdm.org/use#IntermediateFile'))
      end
      it 'has file format of StructuredText' do
        expect(subject.file_format).to include(::RDF::URI('http://pcdm.org/file-format-types#StructuredText'))
      end
    end

    context 'when building new structure' do
      subject { file_set.build_structure }
      it 'initializes an unsaved File object with Structure type and file format' do
        expect(subject).to be_new_record
        expect(subject.metadata_node.type).to include(::RDF::URI('http://pcdm.org/use#IntermediateFile'))
        expect(subject.metadata_node.type).to include(Hydra::PCDM::Vocab::PCDMTerms.File)
        expect(subject.file_format).to include(::RDF::URI('http://pcdm.org/file-format-types#StructuredText'))
      end
    end
  end

  describe '#files_metadata', clean_repo: true do
    let(:file_set) { described_class.create }
    let(:file_1) { Hydra::PCDM::File.new }
    let(:file_metadata) { [{ id: 'an_id', label: 'high', external_file_uri: 'http://test.file' }] }

    context 'when derivative files are present' do
      before do
        file_1.id = 'an_id'
        file_1.label = 'high'
        file_1.external_file_uri = 'http://test.file'
        file_set.files << file_1
      end
      it 'can be saved without errors' do
        expect(file_set.save).to be_truthy
      end
      it 'responds to files_metadata' do
        expect(file_set.files_metadata).to eq(file_metadata)
      end
      it 'responds to to_solr' do
        expect(file_set.to_solr['files_metadata_ssi']).to eq(file_metadata.to_json)
      end
    end
  end
end
