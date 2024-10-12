#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "src/gamemanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // qmlRegisterType<GameManager>("Game", 1, 0, "GameManager");

    GameManager gameManager;
    engine.rootContext()->setContextProperty("GameManager", &gameManager);

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

//    qmlRegisterSingletonInstance("Zortingen", 1, 0, "Mana", GameManager::instance());

//    qmlRegisterType<GameManager>("Zortingen", 1, 0, "Mana");

//    QQmlContext* ctx = engine.rootContext();
//    ctx->setContextProperty("GameManager", GameManager::instance());

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
