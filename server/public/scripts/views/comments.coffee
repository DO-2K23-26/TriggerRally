define [
  'backbone-full'
  'cs!views/view'
  'cs!views/view_collection'
  'jade!templates/comments'
  'jade!templates/comment'
  'cs!views/user'
], (
  Backbone
  View
  ViewCollection
  template
  templateComment
  UserView
) ->
  class CommentView extends View
    template: templateComment
    tagName: 'tr'

    # initialize: ->
    #   @model.fetch()
    #   @root = @options.parent.options.root
    #   @listenTo @model, 'change', @render, @

    # viewModel: ->
    #   data = super
    #   loading = '...'
    #   data.name ?= loading
    #   data.modified_ago ?= loading
    #   data.count_copy ?= loading
    #   data.count_drive ?= loading
    #   data.count_fav ?= loading
    #   data.user ?= null
    #   data

    beforeRender: ->
      @userView?.destroy()

    afterRender: ->
      comment = @model

      $commentuser = @$ '.commentuser'
      @userView = null
      do updateUserView = =>
        @userView?.destroy()
        @userView = comment.user and new UserView
          model: comment.user
        $commentuser.empty()
        $commentuser.append @userView.el if @userView
      @listenTo comment, 'change:user', updateUserView

    destroy: ->
      @beforeRender()
      super

  class CommentListView extends ViewCollection
    view: CommentView
    childOffset: 1  # Ignore header <tr>.

  class CommentsView extends View
    # className: 'overlay'
    className: 'div'
    template: template
    constructor: (model, @app) -> super { model }

    viewModel: ->
      data = super
      data.loggedIn = @app.root.user?
      data

    afterRender: ->
      commentListView = new CommentListView
        collection: @model.comments
        el: @$('table.commentlist')
        root: @app.root
      commentListView.render()
