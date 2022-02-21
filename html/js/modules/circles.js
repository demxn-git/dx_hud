export default {
  HealthIndicator: new ProgressBar.Circle('#HealthIndicator', {
    strokeWidth: 12,
    trailWidth: 12,
  }),
  ArmourIndicator: new ProgressBar.Circle('#ArmourIndicator', {
    color: 'rgb(0, 140, 255)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  }),
  HungerIndicator: new ProgressBar.Circle('#HungerIndicator', {
    color: 'rgb(255, 164, 59)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  }),
  ThirstIndicator: new ProgressBar.Circle('#ThirstIndicator', {
    color: 'rgb(0, 140, 170)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  }),
  StressIndicator: new ProgressBar.Circle('#StressIndicator', {
    color: 'rgb(255, 74, 104)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  }),
  OxygenIndicator: new ProgressBar.Circle('#OxygenIndicator', {
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  }),
  SpeedIndicator: new ProgressBar.Circle('#SpeedIndicator', {
    color: 'rgb(255, 255, 255)',
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
    duration: 250,
  }),
  FuelIndicator: new ProgressBar.Circle('#FuelIndicator', {
    trailColor: 'rgb(35, 35, 35)',
    strokeWidth: 12,
    trailWidth: 12,
  }),
  VoiceIndicator: new ProgressBar.Circle('#VoiceIndicator', {
    strokeWidth: 12,
    trailWidth: 12,
    duration: 100,
  }),
};
