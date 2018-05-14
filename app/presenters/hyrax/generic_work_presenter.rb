# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  class GenericWorkPresenter < Hyrax::WorkShowPresenter
    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::AVFileSetPresenter

    IIIF_DEFAULT_VERSION = 2
    IIIF_DEFAULT_MANIFEST_MIME = "application/json;profile=http://iiif.io/api/presentation/#{IIIF_DEFAULT_VERSION}/context.json".freeze

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

    # @return the highest IIIF version (as an integer) specified in the Accept request header, or the default version if none specified
    def iiif_version
      accept = request.headers['Accept']
      return parse_accept(accept) if accept.present?
      if representative_presenter.present? &&
         (representative_presenter.video? ||
          representative_presenter.audio?)
        3
      else
        IIIF_DEFAULT_VERSION
      end
    end

    private

      def parse_accept(accept)
        version = 0 # assume all valid versions will be at least greater than 0
        # check for multiple profiles for highest IIIF version. Note: only digits are allowed in the version number
        regexp = Regexp.new(Regexp.escape(IIIF_DEFAULT_MANIFEST_MIME[/profile.*$/]).gsub("/#{IIIF_DEFAULT_VERSION}/", "/(\\d+)/"))
        accept.scan(regexp).each do |matched|
          v = matched[0].to_i
          version = v > version ? v : version
        end
        version.zero? ? IIIF_DEFAULT_VERSION : version
      end
  end
end
