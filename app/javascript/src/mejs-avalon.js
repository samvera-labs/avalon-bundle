// Import MediaelementJS source files here.
// The MediaelementJS source files were installed via 'yarn add mediaelement', and the files live in 'node_modules'
import 'mediaelement/build/mediaelement-and-player.js';
import 'mediaelement/build/mediaelementplayer.css';
console.log('MEJS Test')

// Wait for element to be available on the page
$( document ).ready(function() {
  // Wrap the player with Mediaelement
  $('#mediaplayer').mediaelementplayer({
    stretching: 'responsive',
    success: function(mediaElement, originalNode, instance) {
      // do stuff
      console.log('Success')
    }
  })
});
