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

import AvalonPlayer from './AvalonPlayer';
import * as avalonApi from '../avalon-api';

// Mock network requests by Jest convention
jest.mock('../avalon-api');

test('Fetches a manifest only if a valid media object id is supplied', async () => {
  const playerInstance = new AvalonPlayer();
  let manifest = await playerInstance.getManifest('123abc');
  expect(manifest.id).toEqual(
    'http://localhost:3333/concern/generic_works/3484zg88m/manifest'
  );

  expect(await playerInstance.getManifest()).toBeUndefined();
});

test('Setting video source urls is successful if provided a valid manifest object', () => {
  const playerInstance = new AvalonPlayer();
  let urls = playerInstance.setVideoSourceUrls(avalonApi.mockManifest);

  expect(Array.isArray(urls)).toBeTruthy();
  expect(urls.length).toBe(1);
});
