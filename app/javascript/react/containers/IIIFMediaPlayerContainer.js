import React from 'react';
import IIIFPlayer from 'react-iiif-media-player';

// Configuration for the IIIF Media Player
const config = {
  fetch: {
    options: {
      credentials: 'include'
    }
  }
};

const IIIFMediaPlayerContainer = () => <IIIFPlayer config={config} />;

export default IIIFMediaPlayerContainer;
