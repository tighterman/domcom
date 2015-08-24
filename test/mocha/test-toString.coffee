{expect, iit, idescribe, nit, ndescribe} = require('./helper')

{bindings
Component, TransformComponent, Tag, Text,
txt, list, func, if_, case_, func, repeat
accordionGroup, accordion
a, p, span, text, div} = dc

{$a, $b, _a, _b} = bindings({a: 1, b: 2})

describe 'toString', ->
  it 'should toString list of if(tag)', ->
    x = 0
    comp = list(t1=text({onchange: -> x = parseInt(@value); comp.update()}, x), pIf=if_((->x), div(1), div(2)))
    console.log(comp.toString())
    expect(comp.toString()).to.equal  '\n<List>\n  <input type="text" onchange=fn:x = parseInt(this.value);\n\t        return comp.update() value=0><nothing/></input>\n  <if fn:x>\n    <div>\n      1</div>\n    <div>\n      2</div>\n  </if>\n</List>'

  it 'should toString  tag with props', ->
    x = 0
    comp = div({value:1}, 1)
    console.log(comp.toString())
    expect(comp.toString()).to.equal '\n<div value=1>\n  1</div>'

  it 'should toString', ->
    comp = case_((-> x), {1:p(1), 2:p(2), 3:p(3)}, 'others')
    console.log(comp.toString())
    expect(comp.toString()).to.equal '\n<Case fn:x>\n  1: <p>\n    1</p>\n  2: <p>\n    2</p>\n  3: <p>\n    3</p>\n  "others"\n</Case>'
