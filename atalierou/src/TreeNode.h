#ifndef TREENODE_H
#define TREENODE_H
#include <QObject>
#include <QQmlListProperty>
#include <QModelIndex>
#include "ITreeNode.h"

class TreeNode : public QObject, public ITreeNode
{
    Q_OBJECT
public:
    Q_PROPERTY(QQmlListProperty<TreeNode> nodes READ nodes)
    Q_CLASSINFO("DefaultProperty", "nodes")
    TreeNode(QObject *parent = Q_NULLPTR);

    void setParentNode(TreeNode *parent);
    Q_INVOKABLE TreeNode *parentNode() const;
    bool insertNode(TreeNode *node, int pos = (-1));
    QQmlListProperty<TreeNode> nodes();

    TreeNode *childNode(int index) const;
    void clear();

    Q_INVOKABLE int pos() const;
    Q_INVOKABLE int count() const;
    QVariant display() const Q_DECL_OVERRIDE;

    Q_INVOKABLE QList<TreeNode *> getTreeNodes() { return m_nodes;}

private:
    QList<TreeNode *> m_nodes;
    TreeNode *m_parentNode;
};

#endif // TREENODE_H
