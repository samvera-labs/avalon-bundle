import React from 'react';
import ReactDOM from 'react-dom';
import IIIFMediaPlayerContainer from '../react/containers/IIIFMediaPlayerContainer';

document.addEventListener('turbolinks:load', () => {
  ReactDOM.render(
    <IIIFMediaPlayerContainer />,
    document.getElementById('react-mounter')
  );
});
