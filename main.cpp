#include <QApplication>
#include <QQmlApplicationEngine>
#include <QScreen>
#include <QLocale>
#include <QTranslator>
#include <QQuickStyle>
#include "src/fileio.h"
#include "src/globalConfigData.h"
#include "src/user.h"
#include "src/TreeModel.h"
#include "src/ActivityLevelScoreNode.h"
#include "src/ActivityTypeScoreNode.h"
#include "src/ActivityCategoryScoreNode.h"
#include "src/ActivityScoreNode.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));

   // QQuickStyle::setStyle("Imagine");
   // QQuickStyle::setFallbackStyle("Material");
   // qputenv("QT_QUICK_CONTROLS_STYLE", QByteArray("Material"));
   // qputenv("QT_QUICK_CONTROLS_MATERIAL_THEME", QByteArray("Dark"));
    QApplication app(argc, argv);



    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "Ma_chlas_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;

    static qreal ldp = 1.0;
    static qreal  lpt = ldp / 72.0;;
        QScreen *screen = QApplication::primaryScreen();
        if (screen) {
           ldp = screen->devicePixelRatio();
           lpt = ldp / 72.0;
        } else {
            qWarning() << "QScreen required for ptToPx";
        }

    qmlRegisterType<TreeModel>("TreeElements", 1, 0, "TreeModel");
    qmlRegisterType<TreeNode>("TreeElements", 1, 0, "TreeElement");
    qmlRegisterType<ActivityLevelScoreNode>("ActivityTreeElements", 1, 0, "ActivityLevelScoreNode");
    qmlRegisterType<ActivityTypeScoreNode>("ActivityTreeElements", 1, 0, "ActivityTypeScoreNode");
    qmlRegisterType<ActivityCategoryScoreNode>("ActivityTreeElements", 1, 0, "ActivityCategoryScoreNode");
    qmlRegisterType<User>("UserSession", 1, 0, "User");

    qmlRegisterSingletonType("UIUtils", 1, 0, "UI", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QJSValue {
        Q_UNUSED(engine)
            /*dpi = Screen.physicalDotsPerInch / Screen.devicePixelRatio / 160
        pt = 1 / 72 * dpi */
        QJSValue uiValue = scriptEngine->newObject();
        uiValue.setProperty("pt", lpt);
        uiValue.setProperty("dp", ldp);
        return uiValue;
    });


    qmlRegisterSingletonType<GlobalConfigData>("GlobalConfigData",1,0,"GlobalConfigData", &GlobalConfigData::qmlInstance);

    qmlRegisterType<FileIO,1>("FileIO",1,0,"FileIO");


    const QUrl url(QStringLiteral("qrc:/ui/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();

}
