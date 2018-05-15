module Hyrax
  class AVFileSetPresenter < Hyrax::FileSetPresenter
    include DisplaysContent

    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::AVFileSetPresenter
  end
end
