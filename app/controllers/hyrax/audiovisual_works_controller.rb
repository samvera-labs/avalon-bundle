# Generated via
#  `rails generate hyrax:work AudiovisualWork`
module Hyrax
  # Generated controller for AudiovisualWork
  class AudiovisualWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks

    # TODO: Add GenericWorks behaviors to the controller.
    self.curation_concern_type = ::AudiovisualWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::AudiovisualWorkPresenter
  end
end
