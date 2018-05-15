# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'
require 'support/shared_examples/concerns/displays_iiif_spec'

RSpec.describe Hyrax::GenericWorkPresenter do
  it_behaves_like "DisplaysIIIF"
end
