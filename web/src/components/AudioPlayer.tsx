import { useState } from 'react';
import { useNuiEvent } from '../hooks/useNuiEvent';
import buckleAudio from '../assets/audio/buckle.ogg';
import unbuckleAudio from '../assets/audio/unbuckle.ogg';

const AudioPlayer = () => {
  const [audio, setAudio] = useState<HTMLAudioElement>();
  
  const soundPaths: {[key: string]: string} = {
    buckle: buckleAudio,
    unbuckle: unbuckleAudio,
  };

  useNuiEvent('playSound', (data) => {
    if (soundPaths[data]) playAudio(soundPaths[data])
  });

  const playAudio = (path: string) => {
    if (audio) {
      audio.pause()
      audio.currentTime = 0
    }

    const newAudio = new Audio(path);
    newAudio.volume = 0.2;
    newAudio.play()
    setAudio(newAudio)
  };

  return null
};

export default AudioPlayer;