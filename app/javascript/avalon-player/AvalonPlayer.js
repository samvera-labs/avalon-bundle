export default class AvalonPlayer {
  constructor() {
    this.initPlayer();
  }

  initPlayer() {
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
  }
}
