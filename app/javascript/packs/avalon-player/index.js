// Import any custom CSS here
import './styles/avalon-bundle-styles.css';

const initPlayer = () => {
  $('document').ready(() => {
    $('#mejs').mediaelementplayer({
      stretching: 'responsive',
      success: function(mediaElement, originalNode, instance) {
        console.log('mediaElement', mediaElement);
      }
    });
  });
};
export default initPlayer;
