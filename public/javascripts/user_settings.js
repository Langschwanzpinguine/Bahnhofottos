const changeUsernameBtn = document.getElementById('changeUsernameBtn');
const changeUsernameForm = document.getElementById('changeUsernameForm');

changeUsernameBtn.addEventListener('click', () => {
    changeUsernameForm.classList.toggle('hidden');
});