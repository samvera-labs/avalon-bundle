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

const iiifParser = manifest => {
  // Default uri in case grabbing one from the IIIF Manifest fails
  let uri =
    'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

  // Grab a URI from the manifest
  try {
    uri = manifest.content[0].items[0].body[0].items[0].id;
  } catch (error) {
    /* eslint-disable */
    console.error(error);
    /* eslint-enable */
  }
  return uri;
};

export default iiifParser;
