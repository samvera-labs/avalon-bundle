# Generated via
#  `rails generate hyrax:work AudiovisualWork`
module Hyrax
  # Generated controller for AudiovisualWork
  class AudiovisualWorksController < ApplicationController
    # Adds GenericWorks behaviors to the controller.
    # TODO extends GenericWorksController directly?
    include GenericWorksController
    self.curation_concern_type = ::AudiovisualWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::AudiovisualWorkPresenter
  end
end
