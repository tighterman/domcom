###* @api dc(element) - dc component constructor
 *
 * @param element
###
DomNode = require './DomNode'
{Component} = require './core'
{requestAnimationFrame} = require  './dom-util'

componentCache = {}
readyFnList = []

globalDcId = 1

module.exports = dc = (element, options={}) ->
  if typeof element == 'string'
    if options.noCache then querySelector(element, options.all)
    else componentCache[element] or componentCache[element] = querySelector(element, options.all)
  else if element instanceof Node
    if options.noCache then new DomNode(element)
    else
      if element.dcId then componentCache[element.dcId]
      else
        element.dcId = globalDcId++
        componentCache[element.dcId] = new DomNode(element)
  else if element instanceof DomNode then element
  else throw new Error('error type for dc')

querySelector = (selector, all) ->
  if all then new DomNode(document.querySelectorAll(selector))
  else new DomNode(document.querySelector(selector))

dc.ready = (fn) -> readyFnList.push fn

dc.onReady = ->
  for fn in readyFnList
    fn()
  return

dc.render = render = ->
  for comp in rootComponents
    comp.update()

dc.renderLoop = renderLoop = ->
  requestAnimFrame renderLoop
  render()
  return

# can not write window.$document = dc(document)
# why so strange? browser can predict the document.dcId=1, document.body.dcId=2 and assigns it in advance !!!!!!!
document.dcId = globalDcId
window.$document = componentCache[globalDcId] = new DomNode(document)
globalDcId++
document.body.dcId = globalDcId
window.$body = componentCache[globalDcId] = new DomNode(document.body)
globalDcId++

document.addEventListener 'DOMContentLoaded', dc.onReady, false