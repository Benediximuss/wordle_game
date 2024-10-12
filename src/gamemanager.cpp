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

GameManager::GameManager(QObject *parent)
    : QObject(parent),
      guessLimit(6),
      randomWord(randomWord = targetWord.isEmpty())
{
    loadWords();
}

GameManager::~GameManager()
{
    qDebug() << "Game manager destroyed";
}

void GameManager::initializeGame()
{
    initLetters();
    guesses.clear();

    if (randomWord)
        pickTargetWord();
    else
        targetWord = targetWord.toUpper();

    gameStatus = GameStatus::RUNNING;

    qDebug() << "Target word:" << targetWord;

    emit gameInitialized();
}

void GameManager::loadWords()
{
    if (!words.empty())
    {
        return;
    }

    QFile file(filePath);

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        std::cerr << "Error opening file: " << filePath.toStdString() << std::endl;
        return;
    }

    QTextStream in(&file);
    while (!in.atEnd())
    {
        QString line = in.readLine().trimmed().toUpper();
        words.insert(line);
    }

    file.close();
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
    int randomIndex = QRandomGenerator::global()->bounded(words.size());
    auto it = words.begin();
    std::advance(it, randomIndex);
    targetWord = (*it).toUpper();
}

void GameManager::enterGuess(QString guess)
{
    guess = guess.toUpper();

    if (guesses.find(guess) != guesses.end())
    {
        emit invalidGuess("Already guessed");
        return;
    }
    else if (words.find(guess) == words.end())
    {
        emit invalidGuess("No such word");
        return;
    }

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

            emit letterUsed(guess[i], result[i]);
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
            {
                letters[guess[i]] = status;
                emit letterUsed(guess[i], result[i]);
            }
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
