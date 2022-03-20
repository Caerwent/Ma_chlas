#include "slidingpuzzle.h"

#include <math.h>
#include <random>    /* srand, rand */
#include <stdio.h>
#include <algorithm> /* min max */
#include <QJsonObject>
using namespace std;

random_device rd;
default_random_engine eng(rd());
uniform_real_distribution<> distrib(0.0, 1.0);

#define randomInOne() distrib(eng)

Slidingpuzzle::Slidingpuzzle(QObject *parent)
        : QObject(parent)
    {

    }

int randInRange(int min, int max) {
     return min + (int) (randomInOne() * ((max - min) + 1));
 }

void Slidingpuzzle::shuffle2() {

     int nb_permutations;

     int* tab = new int[memSize];
     int* tmp_tab = new int[memSize];
     int parite;

     do {
         nb_permutations = 0;
     /* Initialise le tableau */

         for (int i = 0; i < memSize; i++) {
             tab[i] = i;
         }
     /* Generation aleatoire */

         for (int i = 0; i < memSize; i++) {
             int x = randInRange(i, memSize - 1 - i);
             int tmp = tab[i];
             tab[i] = tab[x];
             tab[x] = tmp;
         }

     /* chercher la parite */
         int i = 0;
         for (i = 0; tab[i] != mEmptyValue; i++) ;

         parite = (mSize - 1) + (mSize - 1) - ((i / mSize) + (i % mSize));

     /* copie du tableau pour comptage */
       //  System.arraycopy(tab, 0, tmp_tab, 0, tab.length);
          memcpy ( tmp_tab, tab, sizeof(int)*memSize );


     /* On positionne 0 en fin */
         if (i < memSize - 1) {
             int tmp = tmp_tab[memSize - 1];
             tmp_tab[memSize - 1] = tmp_tab[i];
             tmp_tab[i] = tmp;
             nb_permutations++;
         }

     /* comptage des permutations restantes */
         for (i = memSize - 1; i > 0; i--) {
             if (tmp_tab[i - 1] < i) {
                 for (int n = i - 1; n >= 0; n--) {
                     if (tmp_tab[n] == i) {
                         int tmp = tmp_tab[n];
                         tmp_tab[n] = tmp_tab[i - 1];
                         tmp_tab[i - 1] = tmp;
                         nb_permutations++;
                     }
                 }
             }
         }
     }
     while (((nb_permutations % 2) ^ (parite % 2)) != 0);

     delete[] tmp_tab;

     for (int i = 0; i < mSize; i++) {
         for (int j = 0; j < mSize; j++) {
             int idxInTab = memSize - 1 - ((i * mSize) + j);
          //   qDebug() << "idxInTab=" << idxInTab << " i="<< i;
             mPuzzleState[i][j] = tab[idxInTab];
         }
     }
     delete[] tab;
 }


 void Slidingpuzzle::shuffle() {
     int col = 0, row = 0;
     for (int i = 0; i < mSize; i++) {
         for (int j = 0; j < mSize; j++) {
             if (mPuzzleState[i][j] == mEmptyValue) {
                 col = j;
                 row = i;
                 break;
             }
         }
     }

     int tmpValue=0;
     int iter=0;
     int lastMove = -1;
     while ( iter < 30) {
         int rand = (int) round(randomInOne() * 4);

         switch (rand) {
             case 0: // left
                 if (col > 1 && lastMove != 1) {
                     tmpValue = mPuzzleState[row][col];
                     mPuzzleState[row][col] = mPuzzleState[row][col - 1];
                     mPuzzleState[row][col - 1] = tmpValue;
                     col = col - 1;
                     lastMove = rand;
                     iter++;
                 }
                 break;
             case 1: // right
                 if (col < mSize - 1 && lastMove != 0) {
                     tmpValue = mPuzzleState[row][col];
                     mPuzzleState[row][col] = mPuzzleState[row][col + 1];
                     mPuzzleState[row][col + 1] = tmpValue;
                     col = col + 1;
                     lastMove = rand;
                    iter++;
                 }
                 break;
             case 2: // top
                 if (row > 1 && lastMove != 3) {
                     tmpValue = mPuzzleState[row][col];
                     mPuzzleState[row][col] = mPuzzleState[row - 1][col];
                     mPuzzleState[row - 1][col] = tmpValue;
                     row = row - 1;
                     lastMove = rand;
                     iter++;
                 }
                 break;
             case 3: // bottom
                 if (row < mSize - 1 && lastMove != 2) {
                     tmpValue = mPuzzleState[row][col];
                     mPuzzleState[row][col] = mPuzzleState[row + 1][col];
                     mPuzzleState[row + 1][col] = tmpValue;
                     row = row + 1;
                     lastMove = rand;
                     iter++;
                 }
                 break;
         }
     }
 }


 void Slidingpuzzle::createPuzzle(int imageSizeInPx, int emptyRowPos, int emptyColPos) {

    mTotalSizeInPx = imageSizeInPx;
    mImgSizeInPx = mTotalSizeInPx/mSize;

     if (mPuzzleState == nullptr) {
         mPuzzleState = new int*[mSize];
         for (int i = 0; i < mSize; i++) {
             mPuzzleState[i] = new int[mSize];

         }
     }
         for (int i = 0; i < mSize; i++) {
             for (int j = 0; j < mSize; j++) {
                 mPuzzleState[i][j] = i * mSize + j;
             }

         }
         if(emptyRowPos>=0 && emptyRowPos<mSize && emptyColPos>=0 && emptyColPos<mSize)
         {
            mEmptyValue = mPuzzleState[emptyRowPos][emptyColPos];
         }
         else
         {
             mEmptyValue = 0;
         }
        emit  easyModeChanged(mEasyMode);

         if (mEasyMode) {
             shuffle();
         } else {
             shuffle2();
         }

    mIsResolved = false;
   emit  isResolvedChanged(mIsResolved);
 }

 void Slidingpuzzle::deletePuzzle()
 {
     if (mPuzzleState != nullptr) {

         for (int i = 0; i < mSize; i++) {
             delete mPuzzleState[i];
         }
         delete[] mPuzzleState;
     }
 }

  int Slidingpuzzle::numToGridRow(int aNum) {
     return aNum / mSize;
 }

  int Slidingpuzzle::numToGridCol(int aNum) {
     return aNum - (aNum / mSize) * mSize;
 }


 int Slidingpuzzle::yToGridRow(float y) {
     return y < 0 ? 0 : min(mSize - 1, (int) ((mTotalSizeInPx - y) / mImgSizeInPx));
 }

 int Slidingpuzzle::xToGridCol(float x) {
     return x < 0 ? 0 : min(mSize - 1, (int) (x / mImgSizeInPx));
 }

QVariant Slidingpuzzle::move(int row, int col) {


    int newRow=0, newCol=0;

    if(row>=0 && row<mSize && col>=0 && col<mSize && mPuzzleState[row][col] != mEmptyValue)
    {
        if(row>0 && mPuzzleState[row-1][col]==mEmptyValue) // test up
        {
            newRow = row-1;
            newCol=col;
        }
        else if(row<mSize-1 && mPuzzleState[row+1][col]==mEmptyValue) // test bottom
        {
            newRow = row+1;
            newCol=col;
        }
        else if(col>0 && mPuzzleState[row][col-1]==mEmptyValue) // test left
        {
            newRow = row;
            newCol=col-1;
        }
        else if(col<mSize-1 && mPuzzleState[row][col+1]==mEmptyValue) // test right
        {
            newRow = row;
            newCol=col+1;
        }
        else {
            return QVariant::fromValue(nullptr);
        }

        mPuzzleState[newRow][newCol] = mPuzzleState[row][col];
        mPuzzleState[row][col] = mEmptyValue;
        checkPuzzleResolution();
        QJsonObject json_item;
        json_item["row"]=newRow-row;
        json_item["col"]=newCol-col;
       return QJsonValue(json_item).toVariant();

    }
    return QVariant::fromValue(nullptr);
}

Q_INVOKABLE bool Slidingpuzzle::canMove(int row, int col)
{
    if(row>=0 && row<mSize && col>=0 && col<mSize && mPuzzleState[row][col] != mEmptyValue)
    {
        if(row>0 && mPuzzleState[row-1][col]==mEmptyValue) // test up
        {
            //qDebug() << "row=" << row << " col=" << col <<" can move up "<<mPuzzleState[row-1][col];
            return true;
        }
        if(row<mSize-1 && mPuzzleState[row+1][col]==mEmptyValue) // test bottom
        {
            //qDebug() << "row=" << row << " col=" << col <<" can move bottom "<<mPuzzleState[row-1][col];
            return true;
        }
        if(col>0 && mPuzzleState[row][col-1]==mEmptyValue) // test left
        {
            //qDebug() << "row=" << row << " col=" << col <<" can move left "<<mPuzzleState[row][col-1];
            return true;
        }
        if(col<mSize-1 && mPuzzleState[row][col+1]==mEmptyValue) // test right
        {
            //qDebug() << "row=" << row << " col=" << col <<" can move right "<<mPuzzleState[row][col+1];
            return true;
        }
    }

    return false;
}

 bool Slidingpuzzle::canMoveToX(int row, int col, float x) {
     if (x < 0 || x > mTotalSizeInPx)
         return false;
     int newCol = xToGridCol(x);
     //       Gdx.app.debug("DEBUG", "canMoveToX row=" + row + " col=" + col + " x="+x+" newCol="+newCol+" state="+mPuzzleState[row][newCol]);
     if (col < mSize && mPuzzleState[row][newCol] == mEmptyValue) {
         return true;
     }

     return false;
 }

 bool Slidingpuzzle::canMoveToY(int row, int col, float y) {
     if (y < 0 || y > mTotalSizeInPx)
         return false;
     int newRow = yToGridRow(y);
     if (row < mSize && mPuzzleState[newRow][col] == mEmptyValue) {
         return true;
     }

     return false;
 }



 void Slidingpuzzle::checkPuzzleResolution() {
     int lastState = -1;
     for (int i = 0; i < mSize; i++) {
         for (int j = 0; j < mSize; j++) {
             if (mPuzzleState[i][j] < lastState) {
                 return;
             }
             lastState = mPuzzleState[i][j];
         }
     }
     mIsResolved = true;
     emit isResolvedChanged(mIsResolved);

 }

 QVariant Slidingpuzzle::getPermutation(int row, int col)
 {
     int value = mPuzzleState[row][col];
     int originalRow = value/mSize;
     int originalCol =  value % mSize;
     QJsonObject json_item;
     json_item["row"]=originalRow;
     json_item["col"]=originalCol;
    return QJsonValue(json_item).toVariant();
 }
