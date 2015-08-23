Component = require './component'
{insertNode, removeNode} = require '../../dom-util'

module.exports = class BaseComponent extends Component
  constructor: (options) -> super(options)

  getBaseComponent: ->
    @mountCallbackComponentList = if @mountCallbackList then [@] else []
    @unmountCallbackComponentList = if @unmountCallbackList then [@] else []
    @oldBaseComponent = @

  attachNode: (parentNode) ->
    {node} = @
    insertNode(parentNode, node, @nextDomNode())
    self = this
    container = @container
    while container
      # for child of list, always be set while createDom or updateDom
      if !self.listIndex? then container.node = node
      self = container
      container = container.container
    return

  remove: (parentNode) ->
    if @node # Nothing.node is null
      removeNode(parentNode, @node)
    @executeUnmountCallback()
    @

  executeMountCallback: ->
    for component in @mountCallbackComponentList
      for cb in component.mountCallbackList then cb()
    return

  executeUnmountCallback: ->
    for component in @unmountCallbackComponentList
      for cb in component.unmountCallbackList then cb()
    return

  isBaseComponent: true
