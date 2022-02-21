window.addEventListener('message', function (event) {
  let data = event.data;

  const Container = document.querySelector('.Container');
  const Logo = document.querySelector('.Logo');
  const ID = document.getElementById('ID');

  if (data.action == 'general') {
    Container.style.display = data.visible ? 'block' : 'none';
    Logo.style.display = data.visible ? 'block' : 'none';

    data.playerId && (ID.textContent = data.playerId);
  }
});
