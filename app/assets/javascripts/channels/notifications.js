App.notifications = App.cable.subscriptions.create('NotificationsChannel', {
  received: function(data) {
    $('#notification-indicator').text(data.unseen_notifications_count);
    $('#notification-indicator').removeClass('d-none');
    $.ajax({
      type: 'GET',
      url: '/notifications',
      headers: {
        Accept: 'application/javascript',
      },
    });
  },
});
