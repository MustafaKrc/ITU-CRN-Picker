function notify(notifier, notificationText, imageSource, notificationColor) {
    if(notifier === undefined || notifier === null)
        return

    notifier.open(notificationText, imageSource, notificationColor)
}
