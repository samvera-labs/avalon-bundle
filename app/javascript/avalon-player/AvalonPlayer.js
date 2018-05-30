/* 
 * Copyright 2011-2018, The Trustees of Indiana University and Northwestern
 * University. Additional copyright may be held by others, as reflected in
 * the commit history.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---  END LICENSE_HEADER BLOCK  ---
*/

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
