
/*
    User information configuration controlled class
    name, surname, phone, email
    - All data is written to a file for right now
*/

#pragma once
#include <QObject>
#include <QVector>
#include <QString>
#include "controllerAdaptor.h"

class Admin : public QObject, ControllerAdaptor
{

    Q_OBJECT
    public:

    Q_INVOKABLE void applyChanges(QString name, QString surname, QString phone, QString mail);

    Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString surname READ getSurname WRITE setSurname NOTIFY surnameChanged)
    Q_PROPERTY(QString phoneNumber READ getPhoneNumber WRITE setPhoneNumber NOTIFY phoneNumberChanged)
    Q_PROPERTY(QString mail READ getMail WRITE setMail NOTIFY mailChanged)

    // these two property are used for keyboard, keyboard is called in the main screen so
    // for textfields in the menu items, width and exsistence of the keyboard should be handled internally.
    Q_PROPERTY(bool keyFlag READ getKeyFlag WRITE setKeyFlag NOTIFY keyFlagChanged)
    Q_PROPERTY(int keyWidth READ getKeyWidth WRITE setKeyWidth NOTIFY keyWidthChanged)

    Admin();
    ~Admin();

    public slots:
        void setName(const QString name);
        void setSurname(const QString surname);
        void setPhoneNumber(const QString phoneNumber);
        void setMail(const QString mail);
        void setKeyboardProp(bool flag, int width);
        void setKeyFlag(bool flag);
        void setKeyWidth(int width);

        QString getName() const;
        QString getSurname() const;
        QString getPhoneNumber() const;
        QString getMail() const;
        bool getKeyFlag() const;
        int getKeyWidth() const;


    signals:
        void nameChanged();
        void surnameChanged();
        void phoneNumberChanged();
        void mailChanged();
        void keyFlagChanged();
        void applyChanges();
        void keyWidthChanged();

    private:
        QString fileName = "admin.conf";
        QString user;
        QString home = "home";
        QString path;
        QString m_name;
        QString m_surname;
        QString m_phoneNumber;
        QString m_mail;
        bool keyFlag;
        int keyWidth;
};
