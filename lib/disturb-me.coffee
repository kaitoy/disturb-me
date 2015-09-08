Disturber = require './disturber'
{CompositeDisposable} = require 'atom'

module.exports = DisturbMe =
  disturber: null
  subscriptions: null

  config:
    bornImage:
      title: 'Born-Image'
      type: 'string'
      default: 'atom://disturb-me/assets/atom/white/atom_born.gif'
    bornDuration:
      title: 'Born-Duration'
      type: 'integer'
      default: 2000
    upImage:
      title: 'Up-Image'
      type: 'string'
      default: 'atom://disturb-me/assets/atom/white/atom.png'
    upSpeed:
      title: 'Up-Speed'
      description: 'The bigger, the faster.'
      type: 'number'
      default: 1
    downImage:
      title: 'Down-Image'
      type: 'string'
      default: 'atom://disturb-me/assets/atom/white/atom.png'
    downSpeed:
      title: 'Down-Speed'
      description: 'The bigger, the faster.'
      type: 'number'
      default: 1
    rightImage:
      title: 'Right-Image'
      type: 'string'
      default: 'atom://disturb-me/assets/atom/white/atom.png'
    rightSpeed:
      title: 'Right-Speed'
      description: 'The bigger, the faster.'
      type: 'number'
      default: 1
    leftImage:
      title: 'Left-Image'
      type: 'string'
      default: 'atom://disturb-me/assets/atom/white/atom.png'
    leftSpeed:
      title: 'Left-Speed'
      description: 'The bigger, the faster.'
      type: 'number'
      default: 1
    dieImage:
      title: 'Die-Image'
      type: 'string'
      default: 'atom://disturb-me/assets/atom/white/atom_die.gif'
    dieDuration:
      title: 'Die-Duration'
      type: 'integer'
      default: 2000

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'disturb-me:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null
    if @disturber?
      @disturber.destroy()
      @disturber = null

  toggle: ->
    if @disturber?
      @disturber.stop()
      @disturber = null
    else
      @disturber = new Disturber(
        atom.config.get('disturb-me.bornImage'),
        atom.config.get('disturb-me.upImage'),
        atom.config.get('disturb-me.downImage'),
        atom.config.get('disturb-me.rightImage'),
        atom.config.get('disturb-me.leftImage'),
        atom.config.get('disturb-me.dieImage'),
        atom.config.get('disturb-me.bornDuration'),
        atom.config.get('disturb-me.upSpeed'),
        atom.config.get('disturb-me.downSpeed'),
        atom.config.get('disturb-me.rightSpeed'),
        atom.config.get('disturb-me.leftSpeed'),
        atom.config.get('disturb-me.dieDuration')
      )
      document.body.appendChild(@disturber.getElement())
      @disturber.start()
