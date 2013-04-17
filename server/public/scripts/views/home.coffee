define [
  'backbone-full'
  'THREE'
  'util/util'
  'client/car'
  'cs!models/index'
  'cs!views/inspector'
  'cs!views/view'
  'jade!templates/home'
], (
  Backbone
  THREE
  util
  clientCar
  models
  InspectorView
  View
  template
) ->
  Vec3 = THREE.Vector3

  class HomeView extends View
    className: 'overlay'
    template: template
    constructor: (@app, @client) -> super()

    afterRender: ->
      do updatePromo = =>
        products = @app.root.user?.products ? []
        @$('.ignition-promo').toggleClass 'hidden', 'ignition' in products

      @listenTo @app.root, 'change:user', updatePromo
      @listenTo @app.root, 'change:user.products', updatePromo
