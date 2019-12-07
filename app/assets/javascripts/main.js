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
