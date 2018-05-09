# Generated via
#  `rails generate hyrax:work AudiovisualWork`
class AudiovisualWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  # Required
  property :date_issued, predicate: ::RDF::Vocab::DC.issued, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
    index.as :stored_searchable
  end
  property :genre, predicate: ::RDF::Vocab::EDM.hasType do |index|
    index.as :stored_searchable, :facetable
  end
  property :topical_subject, predicate: ::RDF::Vocab::DC.subject do |index|
    index.as :stored_searchable, :facetable
  end
  property :geographic_subject, predicate: ::RDF::Vocab::DC.spatial do |index|
    index.as :stored_searchable, :facetable
  end
  property :temporal_subject, predicate: ::RDF::Vocab::BF2.temporalCoverage do |index|
    index.as :stored_searchable, :facetable
  end
  property :physical_description, predicate: ::RDF::URI.new('http://www.rdaregistry.info/Elements/u/#P60550'), multiple: false do |index|
    index.as :stored_searchable
  end
  property :table_of_contents, predicate: ::RDF::Vocab::DC.tableOfContents, multiple: false do |index|
    index.as :stored_searchable
  end
  # This property will put together type and note content in a parsable string
  property :note, predicate: ::RDF::Vocab::SKOS.note do |index|
    index.as :stored_searchable
  end
  # Instead of :related_url this property will put together label and url in a parsable string
  property :related_item, predicate: ::RDF::Vocab::DC.relation do |index|
    index.as :stored_searchable
  end
  # Identifiers
  property :bibliographic_id, predicate: ::RDF::OWL.sameAs, multiple: false do |index|
    index.as :stored_searchable
  end
  property :local, predicate: ::RDF::Vocab::Identifiers.local do |index|
    index.as :stored_searchable
  end
  property :lccn, predicate: ::RDF::Vocab::Identifiers.lccn do |index|
    index.as :stored_searchable
  end
  property :issue_number, predicate: ::RDF::Vocab::Identifiers.method("issue-number").call do |index|
    index.as :stored_searchable
  end
  property :matrix_number, predicate: ::RDF::Vocab::Identifiers.method("matrix-number").call do |index|
    index.as :stored_searchable
  end
  property :music_publisher, predicate: ::RDF::Vocab::Identifiers.method("music-publisher").call do |index|
    index.as :stored_searchable
  end
  property :video_recording_identifier, predicate: ::RDF::Vocab::Identifiers.method("videorecording-identifier").call do |index|
    index.as :stored_searchable
  end
  property :oclc, predicate: ::RDF::URI.new('http://dbpedia.org/ontology/oclc') do |index|
    index.as :stored_searchable
  end

  self.indexer = AudiovisualWorkIndexer
  self.human_readable_type = 'Audiovisual Work'

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }

  # This must be included at the end, because it finalizes the metadata
  # # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
