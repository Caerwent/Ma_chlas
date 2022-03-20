#ifndef SLIDINGPUZZLE_H
#define SLIDINGPUZZLE_H

#include <QObject>
#include <QVariant>

class Slidingpuzzle : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(int size
               READ size
               WRITE setSize
               NOTIFY sizeChanged)
    Q_PROPERTY(bool easyMode
               READ easyMode
               WRITE setEasyMode
               NOTIFY easyModeChanged)
    Q_PROPERTY(bool isResolved
               READ isResolved
               NOTIFY isResolvedChanged)

    explicit Slidingpuzzle(QObject *parent=0);

        ~Slidingpuzzle()
    {
        deletePuzzle();
    }

   Q_INVOKABLE int numToGridRow(int aNum) ;

   Q_INVOKABLE int numToGridCol(int aNum) ;

    Q_INVOKABLE QVariant move(int row, int col) ;
    Q_INVOKABLE bool canMove(int row, int col);

   Q_INVOKABLE int yToGridRow(float y);

   Q_INVOKABLE int xToGridCol(float x);

   Q_INVOKABLE bool canMoveToX(int row, int col, float x) ;

   Q_INVOKABLE bool canMoveToY(int row, int col, float y);

   Q_INVOKABLE void createPuzzle(int imageSizeInPx, int emptyRowPos, int emptyColPos);

    Q_INVOKABLE QVariant getPermutation(int row, int col);
    Q_INVOKABLE int getPuzzleValue(int row, int col) {
        if(mPuzzleState!=nullptr && row>=0 && row<mSize && col>=0 && col<mSize)
        {
            return mPuzzleState[row][col];
        }
        else return 0;
    }
    Q_INVOKABLE int getPuzzleEmptyValue() {
        return mEmptyValue;
    }

public slots:
    void setSize(int newSize) { mSize = newSize;
                                memSize = mSize * mSize;
                              deletePuzzle();
                              mIsResolved=false;
                              emit isResolvedChanged(mIsResolved);
                              }
    int size() { return mSize;}

    void setEasyMode(bool newMode) { mEasyMode = newMode; }
    bool easyMode() { return mEasyMode; }

    bool isResolved() { return mIsResolved; }

signals:
    void sizeChanged(int size);
    void easyModeChanged(bool easyMode);
    void isResolvedChanged(bool isResolved);


private:
    void deletePuzzle();
    void shuffle2();
    void shuffle();
    void checkPuzzleResolution();

    int mSize = 3;
    int memSize = 9;
    int mEmptyValue=0;
    int mImgSizeInPx, mTotalSizeInPx;
    int** mPuzzleState=nullptr;

    bool mIsResolved = false;
    bool mEasyMode = false;
};

#endif // SLIDINGPUZZLE_H
