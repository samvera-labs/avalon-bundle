# Generated via
#  `rails generate hyrax:work AudiovisualWork`
class AudiovisualWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior

  # TODO check multi-value, solr index
  #
  property :bibliographic_id, predicate: Qa::Authorities.Loc.local, multiple: false
  # bibliographic id label, not in avalon ???
  # property :other_identifier ???
  # other identifier label, not in avalon ??? don't see the following fields in Qa::Authorities.Loc
  property :local, predicate: Qa::Authorities.Loc.local, multiple: false
  property :lccn, predicate: Qa::Authorities.Loc.lccn, multiple: false
  property :issue_number, predicate: Qa::Authorities.Loc.issue-number, multiple: false
  property :matrix_number, predicate: Qa::Authorities.Loc.matrix-number, multiple: false
  property :music_publisher, predicate: Qa::Authorities.Loc.music-publisher, multiple: false  # avalon_publisher?
  property :record_identifier, predicate: Qa::Authorities.Loc.videorecording-identifier, multiple: false # record_identifier?
  # property :oclc, predicate: ???::dbpedia.oclc, multiple: false
  # title: seems to be consistent between Hyrax & Avalon, both use ::RDF::Vocab::DC.title, except that in Avalon it's not facetable, in Hyrax it is

  # TODO MARCRelators = Relator?
  property :creator, predicate: ::RDF::Vocab::MARCRelators.cre do |index|
      index.as :stored_searchable, :facetable
  end

  property :contributor, predicate: ::RDF::Vocab::MARCRelators.ctb

  # TODO searchable ???
  property :genre, predicate: ::RDF::Vocab::EDM.hasType do |index|
    index.as :searchable, :facetable
  end

  property :publisher, predicate: ::RDF::Vocab::DC.publisher do |index|
    index.as :searchable
  end

  property :date_created, predicate: ::RDF::Vocab::DC.created, multiple: false
  property :date_issued, predicate: ::RDF::Vocab::DC.issued, multiple: false

  property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
    index.as :searchable
  end

  property :language, predicate: ::RDF::Vocab::DC.language do |index|
    index.as :searchable, :facetable
  end

  property :physical_description, predicate: ::RDF::Vocab::Bibframe.extent, multiple: false
  property :related_item_url, predicate: ::RDF::Vocab::DC.relation, multiple: false
  # Related Item Label ???
  property :topical_subject, predicate: ::RDF::Vocab::DC.subject
  property :geographic_subject, predicate: ::RDF::Vocab::DC.spatial
  property :temporal_subject, predicate: ::RDF::Vocab::BF2.temporalCoverage
  property :permalink, predicate: ::RDF::Vocab::EDM.isShownAt, multiple: false  # not found in avalon ???

  property :terms_of_use, predicate: ::RDF::Vocab::DC.rights do |index|
    index.as :searchable  # TODO searchable?
  end

  property :table_of_contents, predicate: ::RDF::Vocab::DC.tableOfContents, multiple: false
  property :statement_of_responsibility, predicate: ::RDF::Vocab::SKOS.note, multiple: false
  property :note, predicate: ::RDF::Vocab::SKOS.note
  property :note_type, predicate: ::RDF::Vocab::SKOS.note  # not found in avalon, only found note_values ???

  self.indexer = AudiovisualWorkIndexer
  self.human_readable_type = 'Audio Visual Work'

  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  validates :title, presence: { message: 'Your work must have a title.' }

  # # This must be included at the end, because it finalizes the metadata
  # # schema (by adding accepts_nested_attributes)
  # include ::Hyrax::BasicMetadata

end


