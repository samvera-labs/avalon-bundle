require 'rails_helper'

RSpec.describe FileSet do
  let(:file_set) { described_class.create }

  describe '#structure' do
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
end
