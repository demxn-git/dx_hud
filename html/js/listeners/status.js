import Circle from '../modules/circles.js';

window.addEventListener('message', function (event) {
  let data = event.data;

  const Hunger = document.getElementById('HungerIndicator');
  const Thirst = document.getElementById('ThirstIndicator');
  const Stress = document.getElementById('StressIndicator');

  const HungerIcon = document.getElementById('HungerIcon');
  const ThirstIcon = document.getElementById('ThirstIcon');
  const StressIcon = document.getElementById('StressIcon');

  if (data.action == 'status') {
    Hunger.style.display = 'block';
    Thirst.style.display = 'block';
    Stress.style.display = data.stress > 5 ? 'block' : 'none';

    data.hunger < 25 && HungerIcon.classList.toggle('flash');
    data.thirst < 25 && ThirstIcon.classList.toggle('flash');
    data.stress > 50 && StressIcon.classList.toggle('flash');

    Circle.HungerIndicator.animate(data.hunger / 100);
    Circle.ThirstIndicator.animate(data.thirst / 100);
    Circle.StressIndicator.animate(data.stress > 5 ? data.stress / 100 : 0);
  }
});
