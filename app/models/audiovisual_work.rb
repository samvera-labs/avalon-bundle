# Generated via
#  `rails generate hyrax:work AudiovisualWork`
class AudiovisualWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  # Properties copied from Hyrax::BasicMetadata
  property :date_created, predicate: ::RDF::Vocab::DC.created, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end
  property :terms_of_use, predicate: ::RDF::Vocab::DC.rights do |index| # :license in Hyrax
    index.as :stored_searchable
  end
  property :related_item_url, predicate: ::RDF::RDFS.seeAlso do |index| # :related_url in Hyrax
    index.as :stored_searchable
  end
  property :permalink, predicate: ::RDF::Vocab::DC.identifier, multiple: false do |index| # :identifier in Hyrax
    index.as :symbol
  end

  # Properties in lieu of those in Hyrax::BasicMetadata
  property :creator, predicate: ::RDF::Vocab::MARCRelators.cre do |index|
    index.as :stored_searchable, :facetable
  end
  property :contributor, predicate: ::RDF::Vocab::MARCRelators.ctb do |index|
    index.as :stored_searchable, :facetable
  end
  property :publisher, predicate: ::RDF::Vocab::DC.publisher do |index|
    index.as :stored_searchable, :facetable
  end
  property :language, predicate: ::RDF::Vocab::DC.language do |index|
    index.as :stored_searchable, :facetable
  end

  # Properties unique to this work type
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
  property :note, predicate: ::RDF::Vocab::SKOS.note do |index|
    index.as :stored_searchable
  end
  property :related_item_label, predicate: ::RDF::RDFS.label do |index| # labels to match up with :related_item_url
    index.as :stored_searchable
  end
  # Identifiers
  property :bibliographic_id, predicate: ::RDF::OWL.sameAs, multiple: false do |index|
    index.as :stored_searchable
  end
  property :local, predicate: ::RDF::Vocab::Identifiers.local, multiple: false do |index|
    index.as :stored_searchable
  end
  property :lccn, predicate: ::RDF::Vocab::Identifiers.lccn, multiple: false do |index|
    index.as :stored_searchable
  end
  property :issue_number, predicate: ::RDF::Vocab::Identifiers.method("issue-number").call, multiple: false do |index|
    index.as :stored_searchable
  end
  property :matrix_number, predicate: ::RDF::Vocab::Identifiers.method("matrix-number").call, multiple: false do |index|
    index.as :stored_searchable
  end
  property :music_publisher, predicate: ::RDF::Vocab::Identifiers.method("music-publisher").call, multiple: false do |index|
    index.as :stored_searchable
  end
  property :video_recording_identifier, predicate: ::RDF::Vocab::Identifiers.method("videorecording-identifier").call, multiple: false do |index|
    index.as :stored_searchable
  end
  property :oclc, predicate: ::RDF::URI.new('http://dbpedia.org/ontology/oclc'), multiple: false do |index|
    index.as :stored_searchable
  end

  self.indexer = AudiovisualWorkIndexer
  self.human_readable_type = 'Audiovisual Work'

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }
end
