function notify(notifier, notificationText, imageSource, notificationColor) {
    if(notifier === undefined || notifier === null)
        return

    notifier.open(notificationText, imageSource, notificationColor)
}

function secondsToDate(seconds){
    if(seconds < 3600)
        return new Date(seconds * 1000).toISOString().substring(14, 19)

    return new Date(seconds * 1000).toISOString().substring(11, 19)
}

function getScriptPath() {
    return Qt.resolvedUrl(".")
}
