import AvalonPlayer from './AvalonPlayer';
import * as avalonApi from '../avalon-api';

// Mock network requests by Jest convention
jest.mock('../avalon-api');

test('Fetches a manifest only if a valid media object id is supplied', async () => {
  const playerInstance = new AvalonPlayer();
  let manifest = await playerInstance.getManifest('123abc');
  expect(manifest.id).toEqual(
    'http://localhost:3333/concern/generic_works/3484zg88m/manifest'
  );

  expect(await playerInstance.getManifest()).toBeUndefined();
});

test('Setting video source urls is successful if provided a valid manifest object', () => {
  const playerInstance = new AvalonPlayer();
  let urls = playerInstance.setVideoSourceUrls(avalonApi.mockManifest);

  expect(Array.isArray(urls)).toBeTruthy();
  expect(urls.length).toBe(1);
});
