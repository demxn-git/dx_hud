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
    let health = (data.health.current - 100) / (data.health.max - 100);
    let oxygen = data.oxygen.current && data.oxygen.current / data.oxygen.max;

    let vehicle, isDriving;
    vehicle = isDriving = data.vehicle;

    let speed, maxSpeed, percSpeed, fuel;
    isDriving && (speed = vehicle.speed.current * vehicle.unitsMultiplier);
    isDriving && (maxSpeed = vehicle.speed.max * vehicle.unitsMultiplier);
    isDriving && (percSpeed = (speed / maxSpeed) * 0.7);
    isDriving && (fuel = vehicle.fuel && vehicle.fuel / 100);

    health < 0 && (health = 0);
    percSpeed > 1 && (percSpeed = 1);
    oxygen < 0 && (oxygen = 0);

    Health.style.display = 'block';
    Speed.style.display = isDriving ? 'block' : 'none';
    Fuel.style.display = isDriving && fuel !== false ? 'block' : 'none';
    Armour.style.display = data.armour ? 'block' : 'none';
    Oxygen.style.display = oxygen !== false ? 'block' : 'none';
    data.voice.toggled && (Voice.style.display = 'block');

    health && HealthIcon.classList.remove('fa-skull');
    health && HealthIcon.classList.add('fa-heart');
    !health && HealthIcon.classList.remove('fa-heart');
    !health && HealthIcon.classList.add('fa-skull');

    data.voice.connected && VoiceIcon.classList.remove('fa-times');
    data.voice.connected && VoiceIcon.classList.add('fa-microphone');
    !data.voice.connected && VoiceIcon.classList.remove('fa-microphone');
    !data.voice.connected && VoiceIcon.classList.add('fa-times');

    percSpeed >= 0.1 && SpeedIcon.classList.remove('fa-tachometer-alt');
    percSpeed >= 0.1 && (SpeedIcon.textContent = Math.floor(speed));
    percSpeed < 0.1 && SpeedIcon.classList.add('fa-tachometer-alt');
    percSpeed < 0.1 && (SpeedIcon.textContent = '');

    oxygen < 0.1 && OxygenIcon.classList.toggle('flash');

    HealthIndicator.trail.setAttribute('stroke', health ? 'rgb(35, 35, 35)' : 'rgb(255, 0, 0)');
    HealthIndicator.path.setAttribute('stroke', health ? 'rgb(0, 255, 100)' : 'rgb(255, 0, 0)');
    OxygenIndicator.path.setAttribute('stroke', oxygen < 0.1 ? 'rgb(255, 0, 0)' : 'rgb(0, 140, 255)');
    VoiceIndicator.path.setAttribute(
      'stroke',
      data.voice.connected ? (data.voice.talking ? 'rgb(255, 255, 0)' : 'rgb(169, 169, 169)') : 'rgb(255, 0, 0)',
    );
    VoiceIndicator.trail.setAttribute('stroke', data.voice.connected ? 'rgb(35, 35, 35)' : 'rgb(255, 0, 0)');
    FuelIndicator.path.setAttribute('stroke', fuel > 0.2 ? 'rgb(255, 255, 255)' : 'rgb(255, 0, 0)');

    HealthIndicator.animate(health);
    ArmourIndicator.animate(data.armour / 100);
    SpeedIndicator.animate(percSpeed || 0);
    OxygenIndicator.animate((oxygen === false && 1) || oxygen);
    FuelIndicator.animate((fuel === false && 1) || fuel);
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
