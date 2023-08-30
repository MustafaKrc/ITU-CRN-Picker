/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#include <C:/Users/mustafa/Desktop/qt_projects/crn_picker/core/itu_login.py>


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_core_ItuLogin()
{
    qmlRegisterTypesAndRevisions<ItuLogin>("core.ItuLogin", 1);
    qmlRegisterModule("core.ItuLogin", 1, 0);
}

static const QQmlModuleRegistration registration("core.ItuLogin", qml_register_types_core_ItuLogin);
