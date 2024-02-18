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

function snapWindow(position){
    if(Qt.platform.os !== "windows")
        return

    switch(position){
        case Enums.SnapPosition.None:
            break
        case Enums.SnapPosition.Top:
            internal.maximizeRestore()
            break
        case Enums.SnapPosition.TopRight:
            mainWindow.width = Math.max(minimumWidth, mainWindow.screen.desktopAvailableWidth/2)
            mainWindow.height = Math.max(minimumHeight, mainWindow.screen.desktopAvailableHeight/2)
            mainWindow.x = mainWindow.screen.desktopAvailableWidth - mainWindow.width
            mainWindow.y = 0
            windowStatus = Enums.WindowStatus.Normal
            
            break
        case Enums.SnapPosition.Right:
            mainWindow.width = Math.max(minimumWidth, mainWindow.screen.desktopAvailableWidth/2)
            mainWindow.height = mainWindow.screen.desktopAvailableHeight
            mainWindow.x = mainWindow.screen.desktopAvailableWidth - mainWindow.width
            mainWindow.y = 0
            windowStatus = Enums.WindowStatus.Normal
            
            break
        case Enums.SnapPosition.BottomRight:
            mainWindow.width = Math.max(minimumWidth, mainWindow.screen.desktopAvailableWidth/2)
            mainWindow.height = Math.max(minimumHeight, mainWindow.screen.desktopAvailableHeight/2)
            mainWindow.x = mainWindow.screen.desktopAvailableWidth - mainWindow.width
            mainWindow.y = mainWindow.screen.desktopAvailableHeight - mainWindow.height
            windowStatus = Enums.WindowStatus.Normal
            break
        case Enums.SnapPosition.TopLeft:
            mainWindow.width = Math.max(minimumWidth, mainWindow.screen.desktopAvailableWidth/2)
            mainWindow.height = Math.max(minimumHeight, mainWindow.screen.desktopAvailableHeight/2)
            mainWindow.x = 0
            mainWindow.y = 0
            windowStatus = Enums.WindowStatus.Normal
            break    
        case Enums.SnapPosition.Left:
            mainWindow.width = Math.max(minimumWidth, mainWindow.screen.desktopAvailableWidth/2)
            mainWindow.height = mainWindow.screen.desktopAvailableHeight
            mainWindow.x = 0
            mainWindow.y = 0
            windowStatus = Enums.WindowStatus.Normal
            break
        case Enums.SnapPosition.BottomLeft:
            mainWindow.width = Math.max(minimumWidth, mainWindow.screen.desktopAvailableWidth/2)
            mainWindow.height = Math.max(minimumHeight, mainWindow.screen.desktopAvailableHeight/2)
            mainWindow.x = 0
            mainWindow.y = mainWindow.screen.desktopAvailableHeight - mainWindow.height
            windowStatus = Enums.WindowStatus.Normal
            break
    }

}
