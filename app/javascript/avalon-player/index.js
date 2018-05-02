import AvalonPlayer from './AvalonPlayer';
import './styles/avalon-bundle-styles.scss';

const avalonPlayer = new AvalonPlayer();

$('document').ready(() => {
  init();
});

export async function init() {
  const mediaId = avalonPlayer.getMediaObjectId();
  const manifest = await avalonPlayer.getManifest(mediaId);
  avalonPlayer.setVideoSourceUrls(manifest);
  avalonPlayer.wrapWithMediaelementPlayer();
}
