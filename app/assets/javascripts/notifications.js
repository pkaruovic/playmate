$(document).on('ajax:success', '#notifications-pagination-link', function() {
  this.remove();
  markNotificationsAsRead();
});

function markNotificationsAsRead() {
  let ids = [];
  $('[data-notification-seen=false]').each(function() {
    const notificationId = this.id.split('_')[1];
    ids.push(notificationId);
  });
  if (ids.length > 0) {
    $.ajax({
      method: 'PATCH',
      headers: {
        accept: 'application/javascript',
      },
      url: '/notifications/mark_as_read',
      data: {
        ids: ids,
      },
      error: function(e) {
        console.error(e);
      },
    });
  }
}
