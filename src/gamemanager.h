#ifndef GAMEMANAGER_H
#define GAMEMANAGER_H

#include <QObject>
#include <QHash>
#include <QSet>

#include <unordered_set>


class GameManager : public QObject
{
    Q_OBJECT
public:
    explicit GameManager(QObject *parent = nullptr);
    ~GameManager();

    Q_INVOKABLE void initializeGame();
    Q_INVOKABLE void enterGuess(QString);
    Q_INVOKABLE QString getTargetWord();

signals:
    void gameInitialized();

    void invalidGuess();
    void guessResult(QVector<int> guessResult, int currentStatus);

private:
    // Enums
    enum class LetterStatus;
    enum class GameStatus;

    // Predefined
    QString filePath = ":/res/words_14855.txt";

    // Game Logic
    bool customWord = false;
    QString targetWord = "APPLE";
    const int guessLimit = 6;
    GameStatus gameStatus;

    // Data
    QSet<QString> words;
    QHash<QChar, LetterStatus> letters;
    QSet<QString> guesses;

    // Initializers
    void loadWords();
    void initLetters();
    void pickTargetWord();

    // Game Flow
    void processGuess(QString&);


};

#endif // GAMEMANAGER_H
