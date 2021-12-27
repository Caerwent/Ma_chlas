#ifndef ITREENODE_H
#define ITREENODE_H
#include <QObject>
class ITreeNode
{
public:
  virtual QVariant display() const = 0;

};

#endif // ITREENODE_H
