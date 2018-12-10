class AvalonDerivativeService < Hyrax::ActiveEncode::ActiveEncodeDerivativeService
  # HACK: Prepend this derivative service
  Hyrax::DerivativeService.services = [AvalonDerivativeService] + Hyrax::DerivativeService.services

  def create_derivatives(filename)
    super
    # Create thumbnails and posters outside of ActiveEncode for now.
    # Hydra-derivatives's video runner/processor don't have a way to
    # set the size of image derivatives so thumbnail and poster are both the same size for now.
    Hydra::Derivatives::VideoDerivatives.create(filename, outputs: [{ label: :thumbnail, format: 'jpg', url: derivative_url('thumbnail') },
                                                                    { label: :poster, format: 'jpg', url: derivative_url('poster') }])
  end

  # The destination_name parameter has to match up with the file parameter
  # passed to the DownloadsController
  def derivative_url(destination_name)
    path = Hyrax::DerivativePath.derivative_path_for_reference(file_set, destination_name)
    URI("file://#{path}").to_s
  end
end
