class Sync.ChatChatWidget extends Sync.View

  beforeInsert: ($el) ->
    $el.hide()
    @insert($el)

  afterInsert: -> 
  	@$el.addClass 'animated bounceInLeft'
  	@$el.fadeIn 'fast'

  beforeRemove: -> @$el.fadeOut 'slow', => @remove()


class Sync.ModeratedChatChatQnaWidget extends Sync.View

  beforeInsert: ($el) ->
    $el.hide()
    @insert($el)

  afterInsert: -> 
  	@$el.addClass 'animated bounceInLeft'
  	@$el.fadeIn 'fast'

  beforeUpdate: (html, data) ->
  	@update(html)

  beforeRemove: -> @$el.fadeOut 'slow', => @remove()