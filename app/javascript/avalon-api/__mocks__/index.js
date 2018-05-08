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
