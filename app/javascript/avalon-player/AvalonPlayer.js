import 'mediaelement';
import 'mediaelement/build/mediaelementplayer.css';
import * as avalonApi from '../avalon-api';

/* eslint-disable no-unused-vars */
export default class AvalonPlayer {
  async getManifest(mediaId) {
    if (!mediaId) {
      return;
    }
    return await avalonApi.fetchManifest(mediaId);
  }

  getMediaObjectId() {
    return document.getElementById('avalon-viewer-wrapper').dataset.workId;
  }

  setVideoSourceUrls(manifest) {
    if (!manifest || Object.keys(manifest).length === 0) {
      return;
    }
    const url = manifest.items['0'].items['0'].items['0'].body.items['0'].id;
    $('#mejs').html(`<source src="${url}" />`);

    // Eventually we'll want to return all source urls - need clarification on what to put on DOM
    return [url];
  }

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
