# Generated via
#  `rails generate hyrax:work AudiovisualWork`
require 'rails_helper'
require 'support/shared_examples/concerns/displays_iiif_spec'

RSpec.describe Hyrax::AudiovisualWorkPresenter do
  it_behaves_like "DisplaysIIIF"
end
