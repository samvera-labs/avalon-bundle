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
import { init } from './index';

jest.mock('./AvalonPlayer');

beforeEach(() => {
  // Clear all instances and calls to constructor and all methods:
  AvalonPlayer.mockClear();
});

it('The consumer should be able to call new() on AvalonPlayer', () => {
  const instance = new AvalonPlayer();
  // Ensure constructor created the object:
  expect(instance).toBeTruthy();
});

it('We can check if the consumer called the class constructor', () => {
  const instance = new AvalonPlayer();
  expect(AvalonPlayer).toHaveBeenCalledTimes(1);
});
