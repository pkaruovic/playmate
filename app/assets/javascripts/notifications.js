function showNotificationsPopup() {
  $('#notifications-popup').show();
  $('#notifications-popup-overlay').show();
}

function hideNotificationsPopup() {
  $('#notifications-popup').hide();
  $('#notifications-popup-overlay').hide();
  $('#notification-list').html('');
}
