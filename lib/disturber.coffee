jQuery = require 'jquery'
Velocity = require 'velocity-animate'
path = require 'path'

module.exports =
class Disturber
  bornImage: null
  upImage: null
  downImage: null
  rightImage: null
  leftImage: null
  dieImage: null
  bornDuration: undefined
  upSpeed: undefined
  downSpeed: undefined
  rightSpeed: undefined
  leftSpeed: undefined
  dieDuration: undefined
  element: null
  height: 100
  width: 100
  _currentX: undefined
  _currentY: undefined
  _stopping: false

  constructor: (
    bornImage, upImage, downImage, rightImage, leftImage, dieImage,
    bornDuration, upSpeed, downSpeed, rightSpeed, leftSpeed, dieDuration
  ) ->
    @bornImage = bornImage
    @upImage = upImage
    @downImage = downImage
    @rightImage = rightImage
    @leftImage = leftImage
    @dieImage = dieImage
    @bornDuration = bornDuration
    @upSpeed = upSpeed
    @downSpeed = downSpeed
    @rightSpeed = rightSpeed
    @leftSpeed = leftSpeed
    @dieDuration = dieDuration

    body = jQuery('body')
    @_currentX = body.width() / 2 - @width / 2
    @_currentY = body.height() / 2 - @height / 2

    @element = jQuery('<img>')
      .addClass('disturber')
      .css('height', @height)
      .css('width', @width)
      .css('top', @_currentY)
      .css('left', @_currentX)

  destroy: ->
    @element.remove()
    @element = null

  getElement: ->
    @element[0]

  start: ->
    @element.attr('src', @_buildSrcUrl @bornImage)
    setTimeout(jQuery.proxy(@move, @), @bornDuration)

  move: ->
    if not @element?
      return
    if @_stopping
      return

    distance = 100 * @_random(1, 3)
    direction = @_random(1, 4)

    switch direction
      when  1 # down
        yLimit = document.body.clientHeight - @height
        distance = if yLimit < distance + @_currentY then yLimit - @_currentY else distance
        src = @downImage
        translate = {'top': '+=' + distance}
        duration = 5 * distance / @downSpeed
        @_currentY += distance
      when  2 # right
        xLimit = document.body.clientWidth - @width
        distance = if xLimit < distance + @_currentX then xLimit - @_currentX else distance
        src = @rightImage
        translate = {'left': '+=' + distance}
        duration = 5 * distance / @rightSpeed
        @_currentX += distance
      when  3 # up
        distance = if @_currentY < distance then @_currentY else distance
        src = @upImage
        translate = {'top': '-=' + distance}
        duration = 5 * distance / @upSpeed
        @_currentY -= distance
      when  4 # left
        distance = if @_currentX < distance then @_currentX else distance
        src = @leftImage
        translate = {'left': '-=' + distance}
        duration = 5 * distance / @leftSpeed
        @_currentX -= distance

    @element.attr('src', @_buildSrcUrl src)

    Velocity(
      @element,
      translate,
      {
        duration: duration,
        easing: 'linear',
        loop: false,
        complete: jQuery.proxy @move, @
      }
    )

  stop: ->
    @_stopping = true
    Velocity(@element, 'stop')
    @element.attr('src', @_buildSrcUrl @dieImage)
    setTimeout(jQuery.proxy(@destroy, @), @dieDuration)

  _random: (min, max) ->
    return Math.floor(Math.random() * (max - min + 1)) + min;

  _buildSrcUrl: (url) ->
    if url.indexOf('atom://') is 0
      relativePath = path.normalize(url.substr(7))
      atomHome = process.env.ATOM_HOME
      filePath = path.join(atomHome, 'packages', relativePath)
    else
      filePath = url
    return "#{filePath}?time=#{Date.now()}"
