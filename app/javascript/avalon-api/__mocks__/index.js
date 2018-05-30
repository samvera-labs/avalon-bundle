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

export const mockManifest = {
  '@context': [
    'http://www.w3.org/ns/anno.jsonld',
    'http://iiif.io/api/presentation/3/context.json'
  ],
  type: 'Manifest',
  id: 'http://localhost:3333/concern/generic_works/3484zg88m/manifest',
  label: 'mpg test',
  metadata: [
    {
      label: {
        '@none': ['Title']
      },
      value: {
        '@none': ['mpg test']
      }
    },
    {
      label: {
        '@none': ['Creator']
      },
      value: {
        '@none': ['Adam']
      }
    },
    {
      label: {
        '@none': ['Keyword']
      },
      value: {
        '@none': ['testing']
      }
    },
    {
      label: {
        '@none': ['Rights statement']
      },
      value: {
        '@none': ['http://rightsstatements.org/vocab/InC-OW-EU/1.0/']
      }
    }
  ],
  rendering: [],
  items: [
    {
      type: 'Canvas',
      id:
        'http://localhost:3333/concern/generic_works/3484zg88m/manifest/canvas/bk1289888',
      label: 'hubble.mpg',
      items: [
        {
          type: 'AnnotationPage',
          id:
            'http://localhost:3333/concern/generic_works/3484zg88m/manifest/canvas/bk1289888/annotation_page/b529b79d-baf5-4b65-af95-b827330f495e',
          items: [
            {
              type: 'Annotation',
              motivation: 'painting',
              target:
                'http://localhost:3333/concern/generic_works/3484zg88m/manifest/canvas/bk1289888',
              body: {
                type: 'Choice',
                choiceHint: 'user',
                items: [
                  {
                    id: 'http://localhost:3333/downloads/bk1289888?file=mp4',
                    type: 'Video'
                  },
                  {
                    id: 'http://localhost:3333/downloads/bk1289888?file=webm',
                    type: 'Video'
                  }
                ]
              }
            }
          ]
        }
      ],
      width: null,
      height: null,
      duration: null
    }
  ]
};

export function fetchManifest(id) {
  return new Promise((resolve, reject) => {
    // A node way of returning promises almost immediately
    process.nextTick(() => {
      resolve(mockManifest);
    });
  });
}
