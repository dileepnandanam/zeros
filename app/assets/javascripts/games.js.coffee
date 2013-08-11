# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->

  boundary =
    n: "up"
    e: "right"
    w: "left"
    s: "down"

  $('.left, .right, .up, .down').on 'click', ()->
    boundary_element = $(@)
    params = $(@).attr('id').split('_')
    url = $(@).closest('.game_box').data('url')
    $.ajax
      type: "PUT"
      url: url
      data: 
        block: params[0]
        boundary: params[1]
      success: (r)->
        $(boundary_element).addClass('marked')
        mark(r)

  updateGame = ()->
    url = $('.game_box').data('sync')
    $.ajax
      type: "GET"
      url: url + ".json"
      success: (r)->
        mark(r.blocks)
        if($('.user_money').html() != r.money)
          $('.user_money').html(r.money)
        if(r.won)
          $('.my_round').hide()
          $('.opponent_round').hide()
          $('.won').show()
        else if(r.lost)
          $('.my_round').hide()
          $('.opponent_round').hide()
          $('.lost').show()
        else if(r.my_round)
          $('.my_round').show()
          $('.opponent_round').hide()
        else
          $('.my_round').hide()
          $('.opponent_round').show()


  if $('.game_box').length > 0
    setInterval(updateGame, 1000)

  mark = (blocks) ->
    for i in blocks
      block = $('#' + i.id)
      left = $(block).find('.left')
      right = $(block).find('.right')
      up = $(block).find('.up')
      down = $(block).find('.down')
      mid = $(block).find('.mid')

      if i.up == true && $(up).length > 0
        $(up).addClass('marked')
      if i.right == true && $(right).length > 0
        $(right).addClass('marked')
      if i.left == true && $(left).length > 0
        $(left).addClass('marked')
      if i.down == true && $(down).length > 0
        $(down).addClass('marked')
      if i.owner != null
        $(mid).html(i.owner.substring(0,1))
