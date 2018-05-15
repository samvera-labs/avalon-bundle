# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  class GenericWorkPresenter < Hyrax::WorkShowPresenter
    include DisplaysIIIF

    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::AVFileSetPresenter
  end
end
