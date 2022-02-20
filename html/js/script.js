document.addEventListener('DOMContentLoaded', function () {
  HealthIndicator = new ProgressBar.Circle('#HealthIndicator', {
    strokeWidth: 12,
    trailWidth: 12,
  });

  ArmourIndicator = new ProgressBar.Circle('#ArmourIndicator', {
    color: 'rgb(0, 140, 255)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  });

  HungerIndicator = new ProgressBar.Circle('#HungerIndicator', {
    color: 'rgb(255, 164, 59)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  });

  ThirstIndicator = new ProgressBar.Circle('#ThirstIndicator', {
    color: 'rgb(0, 140, 170)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  });

  StressIndicator = new ProgressBar.Circle('#StressIndicator', {
    color: 'rgb(255, 74, 104)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  });

  OxygenIndicator = new ProgressBar.Circle('#OxygenIndicator', {
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  });

  SpeedIndicator = new ProgressBar.Circle('#SpeedIndicator', {
    color: 'rgb(255, 255, 255)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
    duration: 250,
  });

  FuelIndicator = new ProgressBar.Circle('#FuelIndicator', {
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  });

  VoiceIndicator = new ProgressBar.Circle('#VoiceIndicator', {
    strokeWidth: 12,
    trailWidth: 12,
    duration: 100,
  });

  VoiceIndicator.animate(0.66);
});

window.addEventListener('message', function (event) {
  let data = event.data;

  const Speed = document.getElementById('SpeedIndicator');
  const Hunger = document.getElementById('HungerIndicator');
  const Thirst = document.getElementById('ThirstIndicator');
  const Fuel = document.getElementById('FuelIndicator');
  const Voice = document.getElementById('VoiceIndicator');
  const Stress = document.getElementById('StressIndicator');
  const Armour = document.getElementById('ArmourIndicator');
  const Oxygen = document.getElementById('OxygenIndicator');
  const Health = document.getElementById('HealthIndicator');

  const HealthIcon = document.getElementById('HealthIcon');
  const SpeedIcon = document.getElementById('SpeedIcon');
  const VoiceIcon = document.getElementById('VoiceIcon');
  const HungerIcon = document.getElementById('HungerIcon');
  const ThirstIcon = document.getElementById('ThirstIcon');
  const StressIcon = document.getElementById('StressIcon');
  const OxygenIcon = document.getElementById('OxygenIcon');

  const Container = document.querySelector('.Container');
  const Logo = document.querySelector('.Logo');
  const ID = document.getElementById('ID');

  if (data.action == 'general') {
    Container.style.display = data.visible ? 'block' : 'none';
    Logo.style.display = data.visible ? 'block' : 'none';

    data.playerId && (ID.textContent = data.playerId);
  }

  if (data.action == 'base') {
    data.speed > 1 && (speed = 1);
    data.oxygen < 0.1 && (data.oxygen = 0.1);

    Health.style.display = 'block';
    Speed.style.display = data.speed !== false ? 'block' : 'none';
    Fuel.style.display = data.fuel !== false ? 'block' : 'none';
    Armour.style.display = data.armour ? 'block' : 'none';
    Oxygen.style.display = data.oxygen < 1 ? 'block' : 'none';
    data.voice.toggled && (Voice.style.display = 'block');

    data.hp && HealthIcon.classList.remove('fa-skull');
    data.hp && HealthIcon.classList.add('fa-heart');
    !data.hp && HealthIcon.classList.remove('fa-heart');
    !data.hp && HealthIcon.classList.add('fa-skull');

    data.voice.connected && VoiceIcon.classList.remove('fa-times');
    data.voice.connected && VoiceIcon.classList.add('fa-microphone');
    !data.voice.connected && VoiceIcon.classList.remove('fa-microphone');
    !data.voice.connected && VoiceIcon.classList.add('fa-times');

    data.speed >= 0.1 && SpeedIcon.classList.remove('fa-tachometer-alt');
    data.speed >= 0.1 && (SpeedIcon.textContent = Math.floor(data.speed * 100));
    data.speed < 0.1 && SpeedIcon.classList.add('fa-tachometer-alt');
    data.speed < 0.1 && (SpeedIcon.textContent = '');

    data.oxygen < 0.25 && OxygenIcon.classList.toggle('flash');

    HealthIndicator.trail.setAttribute(
      'stroke',
      data.hp ? 'rgb(35, 35, 35)' : 'rgb(255, 0, 0)',
    );
    HealthIndicator.path.setAttribute(
      'stroke',
      data.hp ? 'rgb(0, 255, 100)' : 'rgb(255, 0, 0)',
    );
    OxygenIndicator.path.setAttribute(
      'stroke',
      data.oxygen < 0.25 ? 'rgb(255, 0, 0)' : 'rgb(0, 140, 255)',
    );
    VoiceIndicator.path.setAttribute(
      'stroke',
      data.voice.connected
        ? data.voice.talking
          ? 'rgb(255, 255, 0)'
          : 'rgb(169, 169, 169)'
        : 'rgb(255, 0, 0)',
    );
    VoiceIndicator.trail.setAttribute(
      'stroke',
      data.voice.connected ? 'rgb(35, 35, 35)' : 'rgb(255, 0, 0)',
    );
    FuelIndicator.path.setAttribute(
      'stroke',
      data.fuel > 0.2 ? 'rgb(255, 255, 255)' : 'rgb(255, 0, 0)',
    );

    HealthIndicator.animate(data.hp);
    ArmourIndicator.animate(data.armour);
    SpeedIndicator.animate(data.speed || 0);
    OxygenIndicator.animate(data.oxygen || 1);
    FuelIndicator.animate(data.fuel || 0);
  }

  if (data.action == 'status') {
    Hunger.style.display = 'block';
    Thirst.style.display = 'block';
    Stress.style.display = data.stress > 5 ? 'block' : 'none';

    data.hunger < 25 && HungerIcon.classList.toggle('flash');
    data.thirst < 25 && ThirstIcon.classList.toggle('flash');
    data.stress > 50 && StressIcon.classList.toggle('flash');

    HungerIndicator.animate(data.hunger / 100);
    ThirstIndicator.animate(data.thirst / 100);
    StressIndicator.animate(data.stress > 5 ? data.stress / 100 : 0);
  }

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
