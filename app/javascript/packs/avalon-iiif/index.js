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
