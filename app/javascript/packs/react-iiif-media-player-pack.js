import React from 'react';
import ReactDOM from 'react-dom';
import IIIFMediaPlayerContainer from '../react/containers/IIIFMediaPlayerContainer';

document.addEventListener('turbolinks:before-cache', () => {
  ReactDOM.unmountComponentAtNode(document.getElementById('react-mounter'));
});

document.addEventListener('turbolinks:load', () => {
  ReactDOM.render(
    <IIIFMediaPlayerContainer />,
    document.getElementById('react-mounter')
  );
});
