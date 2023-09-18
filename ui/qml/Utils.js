function notify(notifier, notificationText, imageSource, notificationColor) {
    if(notifier === undefined || notifier === null)
        return

    notifier.open(notificationText, imageSource, notificationColor)
}

function fileExists(filePath) {
    var file = Qt.resolvedUrl(filePath)
    return file !== ""
}
