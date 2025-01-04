// Toast notification logic
export function setupToast() {
    const toast = new bootstrap.Toast(document.getElementById('toast'));
    const toastTitle = document.getElementById('toastTitle');
    const toastMessage = document.getElementById('toastMessage');

    return function showToast(title, message, isError = false) {
        toastTitle.textContent = title;
        toastMessage.textContent = message;
        document.getElementById('toast').classList.toggle('bg-danger', isError);
        toast.show();
    };
}