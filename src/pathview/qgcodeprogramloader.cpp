#include "qgcodeprogramloader.h"

QGCodeProgramLoader::QGCodeProgramLoader(QObject *parent) :
    QObject(parent),
    m_fileName(""),
    m_model(NULL)
{
}

void QGCodeProgramLoader::load()
{
    if (m_model == NULL)
    {
        return;
    }

    QFile file(m_fileName);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    int lineNumber = 0;

    while (!file.atEnd()) {
        file.readLine();
        lineNumber++;
    }

    m_model->beginUpdate();
    m_model->prepareFile(m_fileName, lineNumber);

    lineNumber = 0;
    file.reset();
    while (!file.atEnd()) {
        QByteArray line = file.readLine();
        lineNumber++;
        m_model->setData(m_fileName, lineNumber, QString(line), QGCodeProgramModel::GCodeRole);
    }

    m_model->endUpdate();

    file.close();
}
