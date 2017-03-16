module.exports =
class InfoView
  constructor: (headtext, childs) ->
    # create header
    @headel = document.createElement('div')
    @headel.textContent = headtext

    @children = (@render child for child in childs)

  getTreeView: (ink) ->
    return ink.tree.treeView(@headel, @children)

  render: (child) ->
    el = document.createElement('div')
    el.textContent = child.k + ": " + child.v
    el
