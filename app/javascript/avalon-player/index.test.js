import AvalonPlayer from './AvalonPlayer';
import { init } from './index';

jest.mock('./AvalonPlayer');

beforeEach(() => {
  // Clear all instances and calls to constructor and all methods:
  AvalonPlayer.mockClear();
});

it('The consumer should be able to call new() on AvalonPlayer', () => {
  const instance = new AvalonPlayer();
  // Ensure constructor created the object:
  expect(instance).toBeTruthy();
});

it('We can check if the consumer called the class constructor', () => {
  const instance = new AvalonPlayer();
  expect(AvalonPlayer).toHaveBeenCalledTimes(1);
});
