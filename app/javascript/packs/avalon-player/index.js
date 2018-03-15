import iiifParser from '../avalon-iiif';
// Import any custom CSS here
import './styles/avalon-bundle-styles.css';
// Import a sample manifest
import lunchroomManifest from './lunchroom-manners-manifest.json';

const replaceManifestUri = manifest => {
  const uri = iiifParser(manifest);
  let el = document.getElementById('mejs');

  if (!el) {
    return;
  }
  el.setAttribute('src', uri);
};

const initPlayer = () => {
  $('document').ready(() => {
    // Swap out <video> source with a source parsed from a IIIF manifest
    replaceManifestUri(lunchroomManifest);

    // Initialize Mediaelement on the media HTML element
    /* eslint-disable no-unused-vars, no-console */
    $('#mejs').mediaelementplayer({
      stretching: 'responsive',
      success: function(mediaElement, originalNode, instance) {
        console.log('mediaElement', mediaElement);
      }
    });
    /* eslint-enable no-unused-vars, no-console */
  });
};
export default initPlayer;
