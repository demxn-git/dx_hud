import Circle from '../modules/circles.js';

Circle.VoiceIndicator.animate(0.66);

window.addEventListener('message', function (event) {
  let data = event.data;

  if (data.action == 'voice') {
    switch (data.voiceRange) {
      case 1:
        data.voiceRange = 33;
        break;
      case 2:
        data.voiceRange = 66;
        break;
      case 3:
        data.voiceRange = 100;
        break;
      default:
        data.voiceRange = 33;
        break;
    }

    VoiceIndicator.animate(data.voiceRange / 100);
  }
});
