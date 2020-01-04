$(document).on(
  'turbolinks:load',
  function hideElementNotVisibleToCurrentUser() {
    $('[data-visible-to]').each(function() {
      const visibleTo = this.dataset.visibleTo.split(/\s/);
      const ownerId = parseInt(this.closest('[data-owner-id]').dataset.ownerId);

      if (visibleTo.includes('owner') && currentUser.id !== ownerId) {
        this.remove();
      }
    });
  },
);

function debounce(func, wait, immediate) {
  let timeout;
  return function() {
    const context = this;
    const args = arguments;
    const later = function() {
      timeout = null;
      if (!immediate) {
        func.apply(context, args);
      }
    };
    const callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) {
      func.apply(context, args);
    }
  };
}
