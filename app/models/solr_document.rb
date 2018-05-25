# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension(Hydra::ContentNegotiation)

  # For Audiovisual Work
  attribute :date_issued, Solr::Array, 'date_issued_tesim'
  attribute :abstract, Solr::Array, 'abstract_tesim'
  attribute :physical_description, Solr::String, 'physical_description_tesim'
  attribute :genre, Solr::Array, 'genre_tesim'
  attribute :topical_subject, Solr::Array, 'topical_subject_tesim'
  attribute :temporal_subject, Solr::Array, 'temporal_subject_tesim'
  attribute :geographic_subject, Solr::Array, 'geographic_subject_tesim'
  attribute :permalink, Solr::String, 'permalink_tesim'
  attribute :related_item, Solr::Array, 'related_item_tesim'
  attribute :bibliographic_id, Solr::String, 'bibliographic_id_tesim'
  attribute :local, Solr::Array, 'local_tesim'
  attribute :oclc, Solr::Array, 'oclc_tesim'
  attribute :lccn, Solr::Array, 'lccn_tesim'
  attribute :issue_number, Solr::Array, 'issue_number_tesim'
  attribute :matrix_number, Solr::Array, 'matrix_number_tesim'
  attribute :music_publisher, Solr::Array, 'music_publisher_tesim'
  attribute :video_recording_identifier, Solr::Array, 'video_recording_identifier_tesim'
  attribute :table_of_contents, Solr::String, 'table_of_contents_tesim'
  attribute :note, Solr::Array, 'note_tesim'
  attribute :terms_of_use, Solr::Array, 'terms_of_use_tesim'
end
