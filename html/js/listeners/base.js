import Circle from '../modules/circles.js';

Circle.VoiceIndicator.animate(0.66);

window.addEventListener('message', function (event) {
  let data = event.data;

  const Speed = document.getElementById('SpeedIndicator');
  const Fuel = document.getElementById('FuelIndicator');
  const Voice = document.getElementById('VoiceIndicator');
  const Armour = document.getElementById('ArmourIndicator');
  const Oxygen = document.getElementById('OxygenIndicator');
  const Health = document.getElementById('HealthIndicator');

  const HealthIcon = document.getElementById('HealthIcon');
  const SpeedIcon = document.getElementById('SpeedIcon');
  const VoiceIcon = document.getElementById('VoiceIcon');
  const OxygenIcon = document.getElementById('OxygenIcon');

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

    Circle.HealthIndicator.trail.setAttribute('stroke', health ? 'rgb(35, 35, 35)' : 'rgb(255, 0, 0)');
    Circle.HealthIndicator.path.setAttribute('stroke', health ? 'rgb(0, 255, 100)' : 'rgb(255, 0, 0)');
    Circle.OxygenIndicator.path.setAttribute('stroke', oxygen < 0.1 ? 'rgb(255, 0, 0)' : 'rgb(0, 140, 255)');
    Circle.VoiceIndicator.path.setAttribute(
      'stroke',
      data.voice.connected ? (data.voice.talking ? 'rgb(255, 255, 0)' : 'rgb(169, 169, 169)') : 'rgb(255, 0, 0)',
    );
    Circle.VoiceIndicator.trail.setAttribute('stroke', data.voice.connected ? 'rgb(35, 35, 35)' : 'rgb(255, 0, 0)');
    Circle.FuelIndicator.path.setAttribute('stroke', fuel > 0.2 ? 'rgb(255, 255, 255)' : 'rgb(255, 0, 0)');

    Circle.HealthIndicator.animate(health);
    Circle.ArmourIndicator.animate(data.armour / 100);
    Circle.SpeedIndicator.animate(percSpeed || 0);
    Circle.OxygenIndicator.animate((oxygen === false && 1) || oxygen);
    Circle.FuelIndicator.animate((fuel === false && 1) || fuel);
  }
});
