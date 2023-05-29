import React from 'react';
import ReactDOM from 'react-dom/client';
import { VisibilityProvider } from './providers/VisibilityProvider';
import ServerLogo from './components/ServerLogo';
import AudioPlayer from './components/AudioPlayer';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <VisibilityProvider>
    </VisibilityProvider>
    <ServerLogo />
    <AudioPlayer />
  </React.StrictMode>,
);
