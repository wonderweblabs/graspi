define 'important/one', [
  'important/two'
], (Two) ->

  class Class extends Two

    test: ->
      'DSFDSFSDFSDF'


define 'important/two', [], ->
  class Class
    constructor: ->
      console.log 'YOOO'
      console.log @test()
      console.log $('body')


requirejs ['important/one'], (ABC) ->
  $ ->
    new ABC()
