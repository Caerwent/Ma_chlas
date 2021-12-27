#include "TreeModel.h"
#include <QMetaProperty>
#include <QQmlPropertyMap>



TreeModel::TreeModel(QObject *parent) :
    QAbstractItemModel(parent)
{
    m_rootNode = new TreeNode(nullptr);
}
TreeModel::~TreeModel()
{
    m_rootNode->clear();
    delete m_rootNode;
}

QHash<int, QByteArray> TreeModel::roleNames() const
{
    return m_roles;
}

QVariant TreeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
    {
        qDebug() <<"TreeModel::data invalid index ";
        return QVariant();
    }

    TreeNode *item = static_cast<TreeNode*>(index.internalPointer());
    if(role>Qt::UserRole)
    {

        int initRole = Qt::UserRole + 1;
        QByteArray roleName = m_roles[initRole+role];
        qDebug() << "TreeModel::data rolename="<<roleName.data();
        QVariant name = item->property(roleName.data());
        return name;
    }
    else if (role==Qt::DisplayPropertyRole)
    {
        const QMetaObject* metaObj=item->metaObject();
        if(role>metaObj->propertyCount()-metaObj->propertyOffset())
        {
            qDebug() <<"TreeModel::data invalid role value ";
            return QVariant();
        }
        const QMetaProperty metaProp = metaObj->property(metaObj->propertyOffset()+role);

        QMap<QString, QVariant> ownerData;
        ownerData.insert("name", metaProp.name());
        ownerData.insert("value", item->property(metaProp.name()));
        return QVariant(ownerData);
    }
    else if (role ==Qt::DisplayRole)
    {
        return item->display();
    }
    else return QVariant();


}

Qt::ItemFlags TreeModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return QAbstractItemModel::flags(index);
}

QModelIndex TreeModel::index(int row, int column, const QModelIndex &parent) const
{
    if (!hasIndex(row, column, parent))
        return QModelIndex();

    TreeNode *parentItem = getNode(parent);
    TreeNode *childItem = parentItem->childNode(row);
    if (childItem)
        return createIndex(row, column, childItem);
    else
        return QModelIndex();
}

QModelIndex TreeModel::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return QModelIndex();

    TreeNode *childItem = static_cast<TreeNode*>(index.internalPointer());
    TreeNode *parentItem = static_cast<TreeNode *>(childItem->parentNode());

    if (parentItem == m_rootNode)
        return QModelIndex();

    return createIndex(parentItem->pos(), 0, parentItem);
}

int TreeModel::rowCount(const QModelIndex &parent) const
{
    if (parent.column() > 0)
        return 0;
     TreeNode *parentItem = getNode(parent);
     return parentItem->count();
}

int TreeModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return 1;

    // TreeNode *item = getNode(currentNode);

    // const QMetaObject* metaObj=item->metaObject();

    // return metaObj->propertyCount()-metaObj->propertyOffset();

}

QQmlListProperty<TreeNode> TreeModel::nodes()
{
    return m_rootNode->nodes();
}

QVariantList TreeModel::roles() const
{
    QVariantList list;
    QHashIterator<int, QByteArray> i(m_roles);
    while (i.hasNext()) {
        i.next();
        list.append(i.value());
    }

    return list;
}

void TreeModel::setRoles(const QVariantList &roles)
{
    static int nextRole = Qt::UserRole + 1;
    foreach(auto role, roles) {
        m_roles.insert(nextRole, role.toByteArray());
        nextRole ++;
    }
}

TreeNode *TreeModel::getNodeByIndex(const QModelIndex &index)
{
    if(!index.isValid())
        return nullptr;
    return static_cast<TreeNode *>(index.internalPointer());
}

QModelIndex TreeModel::getIndexByNode(TreeNode *node)
{
    QVector<int> positions;
    QModelIndex result;
    if(node) {
        do
        {
            int pos = node->pos();
            positions.append(pos);
            node = node->parentNode();
        } while(node != nullptr);


        for (int i = positions.size() - 2; i >= 0 ; i--)
        {
            result = index(positions[i], 0, result);
        }
    }
    return result;
}


bool TreeModel::insertNode(TreeNode *childNode, const QModelIndex &parent, int pos)
{
    TreeNode *parentElement = getNode(parent);
    if(pos >= parentElement->count())
        return false;
    if(pos < 0)
        pos = parentElement->count();

    childNode->setParentNode(parentElement);
    beginInsertRows(parent, pos, pos);
    bool retValue = parentElement->insertNode(childNode, pos);
    endInsertRows();
    return retValue;
}

TreeNode *TreeModel::getNode(const QModelIndex &index) const
{
    if(index.isValid())
        return static_cast<TreeNode *>(index.internalPointer());
    return m_rootNode;
}
