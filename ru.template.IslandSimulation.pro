TARGET = ru.template.IslandSimulation

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \

HEADERS += \

DISTFILES += \
    ../../Desktop/фотки для питона/для авроры/18200651-middle1.png \
    ../../Desktop/фотки для питона/для авроры/18200651-middle1.png \
    .gitignore \
    rpm/ru.template.IslandSimulation.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.IslandSimulation.ts \
    translations/ru.template.IslandSimulation-ru.ts \

OTHER_FILES += \
    qml/components/Animal.qml \
    qml/components/Rabbit.qml \
    qml/images/rabbit.png
