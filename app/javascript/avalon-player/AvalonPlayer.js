import { fetchManifest } from '../avalon-api';

/* eslint-disable no-unused-vars */
export default class AvalonPlayer {
  constructor() {
    this.workId;
    this.initializePlayer();
  }

  /**
   * Initialize a mediaelement player instance from the media object's IIIF manifest
   * @return {void}
   */
  initializePlayer() {
    $('document').ready(() => {
      this.workId = this.getMediaObjectId();

      if (!this.workId) {
        return;
      }

      fetchManifest(this.workId)
        .then(response => this.setVideoSourceUrls(response))
        .then(() => this.wrapWithMediaelementPlayer());
    });
  }

  getMediaObjectId() {
    return document.getElementById('avalon-viewer-wrapper').dataset.workId;
  }

  /**
   * Create child <source> elements for HTML <video> or <audio> parent
   * @param  {object}  manifest Current mediaobject IIIF manifest
   * @return {Promise}
   */
  async setVideoSourceUrls(manifest) {
    const url = manifest.items['0'].items['0'].items['0'].body.items['0'].id;
    $('#mejs').html(`<source src="${url}" />`);
  }

  /**
   * Instantiate a Mediaelement wrapper around current HTML5 media element
   * @return {void}
   */
  wrapWithMediaelementPlayer() {
    $('#mejs').mediaelementplayer({
      stretching: 'responsive',
      success: function(mediaElement, originalNode, instance) {
        console.log('mediaElement', mediaElement);
      }
    });
  }
}
/* eslint-enable no-unused-vars */
