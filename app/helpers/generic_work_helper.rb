module GenericWorkHelper
  def iiif_viewer_display(presenter, locals = {})
    render iiif_viewer_display_partial(presenter),
           locals.merge(presenter: presenter)
  end

  def iiif_viewer_display_partial(work_presenter)
    'hyrax/base/iiif_viewers/' + iiif_viewer_for_work(work_presenter).to_s
  end

  def iiif_viewer_for_work(work_presenter)
    if work_presenter.respond_to? :iiif_viewer
      work_presenter.iiif_viewer
    else
      :universal_viewer
    end
  end
end
