// Import any custom CSS here
import './styles/avalon-bundle-styles.css';

const initPlayer = () => {
  $('document').ready(() => {
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
