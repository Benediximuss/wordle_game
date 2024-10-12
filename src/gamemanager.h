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
    void invalidGuess(QString message);
    void guessResult(QVector<int> guessResult, int currentStatus);
    void letterUsed(QChar letter, int status);

private:
    // Enums
    enum class LetterStatus;
    enum class GameStatus;

    QString filePath = ":/res/words_14855.txt";

    // Game Logic
    const int guessLimit = 6;
    QString targetWord = "apple";
    bool randomWord;
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
