# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  class GenericWorkPresenter < Hyrax::WorkShowPresenter
    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::AVFileSetPresenter

    # @return [Boolean] render a IIIF viewer
    def iiif_viewer?
      representative_id.present? &&
        representative_presenter.present? &&
        (representative_presenter.video? ||
         representative_presenter.audio? ||
         (representative_presenter.image? && Hyrax.config.iiif_image_server?))
    end

    alias universal_viewer? iiif_viewer?
    deprecation_deprecate universal_viewer?: "use iiif_viewer? instead"

    def iiif_viewer
      if representative_presenter.video? || representative_presenter.audio?
        :avalon
      elsif representative_presenter.image?
        :universal_viewer
      end
    end
  end
end
