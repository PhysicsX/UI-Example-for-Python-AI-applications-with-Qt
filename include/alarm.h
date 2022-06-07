
/*
    This clsas is used for notification configuration
    Audio, email alarm, led status, flashlight statu
    All data is written to a file for right now
*/


#include <QObject>
#include <QVector>
#include <QString>

class Alarm : public QObject
{

    Q_OBJECT
    public:
    //update the file or configuration
    Q_INVOKABLE void applyChanges(bool audio, bool text, bool mail, bool ledStatu, bool flashHigh, bool flashLow);

    Q_PROPERTY(bool audio READ getAudio WRITE setAudio NOTIFY audioChanged)
    Q_PROPERTY(bool text READ getText WRITE setText NOTIFY textChanged)
    Q_PROPERTY(bool mail READ getMail WRITE setMail NOTIFY mailChanged)
    Q_PROPERTY(bool ledStatu READ getLedStatu WRITE setLedStatu NOTIFY ledStatuChanged)
    Q_PROPERTY(bool flashHigh READ getFlashHigh WRITE setFlashHigh  NOTIFY flashHighChanged)
    Q_PROPERTY(bool flashLow READ getFlashLow WRITE setFlashLow NOTIFY flashLowChanged)

    Alarm();
    ~Alarm();

    public slots:
        void setAudio(const bool arg);
        void setText(const bool arg);
        void setMail(const bool arg);
        void setLedStatu(const bool arg);
        void setFlashHigh(const bool arg);
        void setFlashLow(const bool arg);

        bool getAudio() const;
        bool getText() const;
        bool getMail() const;
        bool getLedStatu() const;
        bool getFlashHigh() const;
        bool getFlashLow() const;

    signals:
        void audioChanged();
        void textChanged();
        void mailChanged();
        void ledStatuChanged();
        void flashHighChanged();
        void flashLowChanged();

    private:
        QString fileName = "notifications.conf";
        QString user;
        QString home = "home";
        QString path;
        bool m_audio;
        bool m_text;
        bool m_mail;
        bool m_ledStatu;
        bool m_flashHigh;
        bool m_flashLow;

};
