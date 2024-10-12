#include "gamemanager.h"

#include <iostream>
#include <algorithm>

#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QTimer>
#include <QRandomGenerator>

enum class GameManager::LetterStatus
{
    WRONG,
    MISPLACED,
    CORRECT,
    NOT_USED
};

enum class GameManager::GameStatus
{
    RUNNING,
    WON,
    LOST
};

GameManager::GameManager(QObject *parent) : QObject(parent)
{
    qDebug() << "Game Manager created...";
}

GameManager::~GameManager()
{
    qDebug() << "Game manager destroyed";
}

void GameManager::tester()
{
    qDebug() << "Run tester...";
}

void GameManager::initializeGame()
{
    bool loaded = loadWords();

    QTimer::singleShot(
        500, this, [=]()
        { emit wordsLoaded(words.size()); });

    if (!loaded)
        return;

    initLetters();

    guesses.clear();

    if (!customWord)
        pickTargetWord();

    gameStatus = GameStatus::RUNNING;

    qDebug() << "Target word:" << targetWord;

    emit gameInitialized();
}

bool GameManager::loadWords()
{
    if (!words.empty())
    {
        qDebug() << "Already loaded with" << words.size() << "words";
        return true;
    }

    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        std::cerr << "Error opening file: " << filePath.toStdString() << std::endl;
        return false;
    }

    QTextStream in(&file);
    while (!in.atEnd())
    {
        QString line = in.readLine().trimmed().toUpper();
        words.insert(line);
    }

    file.close();

    return true;
}

void GameManager::initLetters()
{
    for (char letter = 'A'; letter <= 'Z'; letter++)
    {
        letters[letter] = LetterStatus::NOT_USED;
    }
}

void GameManager::pickTargetWord()
{
    // std::srand(std::time(0));
    // size_t randomIndex = std::rand() % words.size();
    // auto it = words.begin();
    // std::advance(it, randomIndex);
    // targetWord = *it;

    int randomIndex = QRandomGenerator::global()->bounded(words.size());
    auto it = words.begin();
    std::advance(it, randomIndex);
    targetWord = (*it).toUpper();
}

void GameManager::enterGuess(QString guess)
{
    bool isValid = false;

    guess = guess.toUpper();

    if (guesses.find(guess) != guesses.end())
    {
        qDebug() << "Already guessed" << guess;
    }
    // else if (words.find(guess) == words.end())
    // {
    //     qDebug() << "No such word" << guess;
    // }
    else
    {
        isValid = true;
    }

    if (!isValid)
        emit invalidGuess();
    else
        processGuess(guess);
}

QString GameManager::getTargetWord()
{
    return targetWord;
}

void GameManager::processGuess(QString &guess)
{
    QHash<QChar, int> targetLetterCount;

    for (QChar c : targetWord)
    {
        targetLetterCount[c]++;
    }

    QVector<int> result(5);

    for (int i = 0; i < targetWord.length(); i++)
    {
        if (guess[i] == targetWord[i])
        {
            letters[guess[i]] = LetterStatus::CORRECT;
            result[i] = (int)LetterStatus::CORRECT;
            targetLetterCount[guess[i]]--;
        }
    }

    for (int i = 0; i < guess.length(); i++)
    {
        if (result[i] != (int)LetterStatus::CORRECT)
        {
            LetterStatus status;

            if (targetLetterCount[guess[i]] > 0)
            {
                status = LetterStatus::MISPLACED;
                targetLetterCount[guess[i]]--;
            }
            else
            {
                status = LetterStatus::WRONG;
            }

            result[i] = (int)status;

            if (letters[guess[i]] == LetterStatus::NOT_USED)
                letters[guess[i]] = status;
        }
    }

    guesses.insert(guess);

    if (std::all_of(result.begin(), result.end(),
                    [&](int s)
                    { return s == (int)LetterStatus::CORRECT; }))
    {
        gameStatus = GameStatus::WON;
    }
    else if (guesses.size() == guessLimit)
    {
        gameStatus = GameStatus::LOST;
    }

    emit guessResult(result, (int)gameStatus);
}
