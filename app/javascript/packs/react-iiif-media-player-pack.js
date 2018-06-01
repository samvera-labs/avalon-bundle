import React from 'react';
import ReactDOM from 'react-dom';
import IIIFMediaPlayerContainer from '../react/containers/IIIFMediaPlayerContainer';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <IIIFMediaPlayerContainer />,
    document.getElementById('react-mounter')
  );
});
