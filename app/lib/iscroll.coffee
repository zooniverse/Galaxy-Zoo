#!
# * iScroll v4.2.2 ~ Copyright (c) 2012 Matteo Spinelli, http://cubiq.org
# * Released under MIT license, http://cubiq.org/license
# 

((window, doc) ->
  
  # Style properties
  
  # Browser capabilities
  
  # Helpers
  
  # Constructor
  
  # Default options
  # Experimental
  
  # Scrollbar
  
  # Zoom
  
  # Snap
  
  # Events
  
  # User defined options
  
  # Set starting position
  
  # Normalize options
  
  # Helpers FIX ANDROID BUG!
  # translate3d and scale doesn't work together!
  # Ignoring 3d ONLY WHEN YOU SET that.options.zoom
  
  # Set some default styles
  
  # Prototype
  
  # Create the scrollbar wrapper
  
  # Create the scrollbar indicator
  
  # Reset position
  
  # Gesture start
  
  # Very lame general purpose alternative to CSSMatrix
  # Needed by snap threshold
  
  # Zoom
  
  # Slow down if outside of the boundaries
  
  # Lock direction
  
  # Double tapped
  # 200 is default zoom duration
  
  # Find the last touched element
  
  # Do we need to snap?
  
  # Do we need to snap?
  # Execute custom code on scroll end
  
  ###
  Utilities
  ###
  # Execute custom code on animation end
  
  # Proportinally reduce speed if we are outside of the boundaries
  
  # Check page X
  
  # Check page Y
  
  # Snap with constant speed (proportional duration)
  
  ###
  Public methods
  ###
  
  # Remove the scrollbars
  
  # Remove the event listeners
  
  # Prepare snap
  
  # Prepare the scrollbars
  
  # If disabled after touchstart we make sure that there are no left over events
  prefixStyle = (style) ->
    return style  if vendor is ""
    style = style.charAt(0).toUpperCase() + style.substr(1)
    vendor + style
  m = Math
  dummyStyle = doc.createElement("div").style
  vendor = (->
    vendors = "t,webkitT,MozT,msT,OT".split(",")
    t = undefined
    i = 0
    l = vendors.length
    while i < l
      t = vendors[i] + "ransform"
      return vendors[i].substr(0, vendors[i].length - 1)  if t of dummyStyle
      i++
    false
  )()
  cssVendor = (if vendor then "-" + vendor.toLowerCase() + "-" else "")
  transform = prefixStyle("transform")
  transitionProperty = prefixStyle("transitionProperty")
  transitionDuration = prefixStyle("transitionDuration")
  transformOrigin = prefixStyle("transformOrigin")
  transitionTimingFunction = prefixStyle("transitionTimingFunction")
  transitionDelay = prefixStyle("transitionDelay")
  isAndroid = (/android/g).test(navigator.appVersion)
  isIDevice = (/iphone|ipad/g).test(navigator.appVersion)
  isTouchPad = (/hp-tablet/g).test(navigator.appVersion)
  has3d = prefixStyle("perspective") of dummyStyle
  hasTouch = "ontouchstart" of window and not isTouchPad
  hasTransform = !!vendor
  hasTransitionEnd = prefixStyle("transition") of dummyStyle
  RESIZE_EV = (if "onorientationchange" of window then "orientationchange" else "resize")
  START_EV = (if hasTouch then "touchstart" else "mousedown")
  MOVE_EV = (if hasTouch then "touchmove" else "mousemove")
  END_EV = (if hasTouch then "touchend" else "mouseup")
  CANCEL_EV = (if hasTouch then "touchcancel" else "mouseup")
  WHEEL_EV = (if vendor is "Moz" then "DOMMouseScroll" else "mousewheel")
  TRNEND_EV = (->
    return false  if vendor is false
    transitionEnd =
      "": "transitionend"
      webkit: "webkitTransitionEnd"
      Moz: "transitionend"
      O: "otransitionend"
      ms: "MSTransitionEnd"

    transitionEnd[vendor]
  )()
  nextFrame = (->
    window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
      setTimeout callback, 1
  )()
  cancelFrame = (->
    window.cancelRequestAnimationFrame or window.webkitCancelAnimationFrame or window.webkitCancelRequestAnimationFrame or window.mozCancelRequestAnimationFrame or window.oCancelRequestAnimationFrame or window.msCancelRequestAnimationFrame or clearTimeout
  )()
  translateZ = (if has3d then " translateZ(0)" else "")
  iScroll = (el, options) ->
    that = this
    i = undefined
    that.wrapper = (if typeof el is "object" then el else doc.getElementById(el))
    that.wrapper.style.overflow = "hidden"
    that.scroller = that.wrapper.children[0]
    that.options =
      hScroll: true
      vScroll: true
      x: 0
      y: 0
      bounce: true
      bounceLock: false
      momentum: true
      lockDirection: true
      useTransform: true
      useTransition: false
      topOffset: 0
      checkDOMChanges: false
      handleClick: true
      hScrollbar: true
      vScrollbar: true
      fixedScrollbar: isAndroid
      hideScrollbar: isIDevice
      fadeScrollbar: isIDevice and has3d
      scrollbarClass: ""
      zoom: false
      zoomMin: 1
      zoomMax: 4
      doubleTapZoom: 2
      wheelAction: "scroll"
      snap: false
      snapThreshold: 1
      onRefresh: null
      onBeforeScrollStart: (e) ->
        e.preventDefault()

      onScrollStart: null
      onBeforeScrollMove: null
      onScrollMove: null
      onBeforeScrollEnd: null
      onScrollEnd: null
      onTouchEnd: null
      onDestroy: null
      onZoomStart: null
      onZoom: null
      onZoomEnd: null

    for i of options
      that.options[i] = options[i]
    that.x = that.options.x
    that.y = that.options.y
    that.options.useTransform = hasTransform and that.options.useTransform
    that.options.hScrollbar = that.options.hScroll and that.options.hScrollbar
    that.options.vScrollbar = that.options.vScroll and that.options.vScrollbar
    that.options.zoom = that.options.useTransform and that.options.zoom
    that.options.useTransition = hasTransitionEnd and that.options.useTransition
    translateZ = ""  if that.options.zoom and isAndroid
    that.scroller.style[transitionProperty] = (if that.options.useTransform then cssVendor + "transform" else "top left")
    that.scroller.style[transitionDuration] = "0"
    that.scroller.style[transformOrigin] = "0 0"
    that.scroller.style[transitionTimingFunction] = "cubic-bezier(0.33,0.66,0.66,1)"  if that.options.useTransition
    if that.options.useTransform
      that.scroller.style[transform] = "translate(" + that.x + "px," + that.y + "px)" + translateZ
    else
      that.scroller.style.cssText += ";position:absolute;top:" + that.y + "px;left:" + that.x + "px"
    that.options.fixedScrollbar = true  if that.options.useTransition
    that.refresh()
    that._bind RESIZE_EV, window
    that._bind START_EV
    that._bind WHEEL_EV  unless that.options.wheelAction is "none"  unless hasTouch
    if that.options.checkDOMChanges
      that.checkDOMTime = setInterval(->
        that._checkDOMChanges()
      , 500)

  iScroll:: =
    enabled: true
    x: 0
    y: 0
    steps: []
    scale: 1
    currPageX: 0
    currPageY: 0
    pagesX: []
    pagesY: []
    aniTime: null
    wheelZoomCount: 0
    handleEvent: (e) ->
      that = this
      switch e.type
        when START_EV
          return  if not hasTouch and e.button isnt 0
          that._start e
        when MOVE_EV
          that._move e
        when END_EV, CANCEL_EV
          that._end e
        when RESIZE_EV
          that._resize()
        when WHEEL_EV
          that._wheel e
        when TRNEND_EV
          that._transitionEnd e

    _checkDOMChanges: ->
      return  if @moved or @zoomed or @animating or (@scrollerW is @scroller.offsetWidth * @scale and @scrollerH is @scroller.offsetHeight * @scale)
      @refresh()

    _scrollbar: (dir) ->
      that = this
      bar = undefined
      unless that[dir + "Scrollbar"]
        if that[dir + "ScrollbarWrapper"]
          that[dir + "ScrollbarIndicator"].style[transform] = ""  if hasTransform
          that[dir + "ScrollbarWrapper"].parentNode.removeChild that[dir + "ScrollbarWrapper"]
          that[dir + "ScrollbarWrapper"] = null
          that[dir + "ScrollbarIndicator"] = null
        return
      unless that[dir + "ScrollbarWrapper"]
        bar = doc.createElement("div")
        if that.options.scrollbarClass
          bar.className = that.options.scrollbarClass + dir.toUpperCase()
        else
          bar.style.cssText = "position:absolute;z-index:100;" + ((if dir is "h" then "height:7px;bottom:1px;left:2px;right:" + ((if that.vScrollbar then "7" else "2")) + "px" else "width:7px;bottom:" + ((if that.hScrollbar then "7" else "2")) + "px;top:2px;right:1px"))
        bar.style.cssText += ";pointer-events:none;" + cssVendor + "transition-property:opacity;" + cssVendor + "transition-duration:" + ((if that.options.fadeScrollbar then "350ms" else "0")) + ";overflow:hidden;opacity:" + ((if that.options.hideScrollbar then "0" else "1"))
        that.wrapper.appendChild bar
        that[dir + "ScrollbarWrapper"] = bar
        bar = doc.createElement("div")
        bar.style.cssText = "position:absolute;z-index:100;background:rgba(0,0,0,0.5);border:1px solid rgba(255,255,255,0.9);" + cssVendor + "background-clip:padding-box;" + cssVendor + "box-sizing:border-box;" + ((if dir is "h" then "height:100%" else "width:100%")) + ";" + cssVendor + "border-radius:3px;border-radius:3px"  unless that.options.scrollbarClass
        bar.style.cssText += ";pointer-events:none;" + cssVendor + "transition-property:" + cssVendor + "transform;" + cssVendor + "transition-timing-function:cubic-bezier(0.33,0.66,0.66,1);" + cssVendor + "transition-duration:0;" + cssVendor + "transform: translate(0,0)" + translateZ
        bar.style.cssText += ";" + cssVendor + "transition-timing-function:cubic-bezier(0.33,0.66,0.66,1)"  if that.options.useTransition
        that[dir + "ScrollbarWrapper"].appendChild bar
        that[dir + "ScrollbarIndicator"] = bar
      if dir is "h"
        that.hScrollbarSize = that.hScrollbarWrapper.clientWidth
        that.hScrollbarIndicatorSize = m.max(m.round(that.hScrollbarSize * that.hScrollbarSize / that.scrollerW), 8)
        that.hScrollbarIndicator.style.width = that.hScrollbarIndicatorSize + "px"
        that.hScrollbarMaxScroll = that.hScrollbarSize - that.hScrollbarIndicatorSize
        that.hScrollbarProp = that.hScrollbarMaxScroll / that.maxScrollX
      else
        that.vScrollbarSize = that.vScrollbarWrapper.clientHeight
        that.vScrollbarIndicatorSize = m.max(m.round(that.vScrollbarSize * that.vScrollbarSize / that.scrollerH), 8)
        that.vScrollbarIndicator.style.height = that.vScrollbarIndicatorSize + "px"
        that.vScrollbarMaxScroll = that.vScrollbarSize - that.vScrollbarIndicatorSize
        that.vScrollbarProp = that.vScrollbarMaxScroll / that.maxScrollY
      that._scrollbarPos dir, true

    _resize: ->
      that = this
      setTimeout (->
        that.refresh()
      ), (if isAndroid then 200 else 0)

    _pos: (x, y) ->
      return  if @zoomed
      x = (if @hScroll then x else 0)
      y = (if @vScroll then y else 0)
      if @options.useTransform
        @scroller.style[transform] = "translate(" + x + "px," + y + "px) scale(" + @scale + ")" + translateZ
      else
        x = m.round(x)
        y = m.round(y)
        @scroller.style.left = x + "px"
        @scroller.style.top = y + "px"
      @x = x
      @y = y
      @_scrollbarPos "h"
      @_scrollbarPos "v"

    _scrollbarPos: (dir, hidden) ->
      that = this
      pos = (if dir is "h" then that.x else that.y)
      size = undefined
      return  unless that[dir + "Scrollbar"]
      pos = that[dir + "ScrollbarProp"] * pos
      if pos < 0
        unless that.options.fixedScrollbar
          size = that[dir + "ScrollbarIndicatorSize"] + m.round(pos * 3)
          size = 8  if size < 8
          that[dir + "ScrollbarIndicator"].style[(if dir is "h" then "width" else "height")] = size + "px"
        pos = 0
      else if pos > that[dir + "ScrollbarMaxScroll"]
        unless that.options.fixedScrollbar
          size = that[dir + "ScrollbarIndicatorSize"] - m.round((pos - that[dir + "ScrollbarMaxScroll"]) * 3)
          size = 8  if size < 8
          that[dir + "ScrollbarIndicator"].style[(if dir is "h" then "width" else "height")] = size + "px"
          pos = that[dir + "ScrollbarMaxScroll"] + (that[dir + "ScrollbarIndicatorSize"] - size)
        else
          pos = that[dir + "ScrollbarMaxScroll"]
      that[dir + "ScrollbarWrapper"].style[transitionDelay] = "0"
      that[dir + "ScrollbarWrapper"].style.opacity = (if hidden and that.options.hideScrollbar then "0" else "1")
      that[dir + "ScrollbarIndicator"].style[transform] = "translate(" + ((if dir is "h" then pos + "px,0)" else "0," + pos + "px)")) + translateZ

    _start: (e) ->
      that = this
      point = (if hasTouch then e.touches[0] else e)
      matrix = undefined
      x = undefined
      y = undefined
      c1 = undefined
      c2 = undefined
      return  unless that.enabled
      that.options.onBeforeScrollStart.call that, e  if that.options.onBeforeScrollStart
      that._transitionTime 0  if that.options.useTransition or that.options.zoom
      that.moved = false
      that.animating = false
      that.zoomed = false
      that.distX = 0
      that.distY = 0
      that.absDistX = 0
      that.absDistY = 0
      that.dirX = 0
      that.dirY = 0
      if that.options.zoom and hasTouch and e.touches.length > 1
        c1 = m.abs(e.touches[0].pageX - e.touches[1].pageX)
        c2 = m.abs(e.touches[0].pageY - e.touches[1].pageY)
        that.touchesDistStart = m.sqrt(c1 * c1 + c2 * c2)
        that.originX = m.abs(e.touches[0].pageX + e.touches[1].pageX - that.wrapperOffsetLeft * 2) / 2 - that.x
        that.originY = m.abs(e.touches[0].pageY + e.touches[1].pageY - that.wrapperOffsetTop * 2) / 2 - that.y
        that.options.onZoomStart.call that, e  if that.options.onZoomStart
      if that.options.momentum
        if that.options.useTransform
          matrix = getComputedStyle(that.scroller, null)[transform].replace(/[^0-9\-.,]/g, "").split(",")
          x = +matrix[4]
          y = +matrix[5]
        else
          x = +getComputedStyle(that.scroller, null).left.replace(/[^0-9-]/g, "")
          y = +getComputedStyle(that.scroller, null).top.replace(/[^0-9-]/g, "")
        if x isnt that.x or y isnt that.y
          if that.options.useTransition
            that._unbind TRNEND_EV
          else
            cancelFrame that.aniTime
          that.steps = []
          that._pos x, y
          that.options.onScrollEnd.call that  if that.options.onScrollEnd
      that.absStartX = that.x
      that.absStartY = that.y
      that.startX = that.x
      that.startY = that.y
      that.pointX = point.pageX
      that.pointY = point.pageY
      that.startTime = e.timeStamp or Date.now()
      that.options.onScrollStart.call that, e  if that.options.onScrollStart
      that._bind MOVE_EV, window
      that._bind END_EV, window
      that._bind CANCEL_EV, window

    _move: (e) ->
      that = this
      point = (if hasTouch then e.touches[0] else e)
      deltaX = point.pageX - that.pointX
      deltaY = point.pageY - that.pointY
      newX = that.x + deltaX
      newY = that.y + deltaY
      c1 = undefined
      c2 = undefined
      scale = undefined
      timestamp = e.timeStamp or Date.now()
      that.options.onBeforeScrollMove.call that, e  if that.options.onBeforeScrollMove
      if that.options.zoom and hasTouch and e.touches.length > 1
        c1 = m.abs(e.touches[0].pageX - e.touches[1].pageX)
        c2 = m.abs(e.touches[0].pageY - e.touches[1].pageY)
        that.touchesDist = m.sqrt(c1 * c1 + c2 * c2)
        that.zoomed = true
        scale = 1 / that.touchesDistStart * that.touchesDist * @scale
        if scale < that.options.zoomMin
          scale = 0.5 * that.options.zoomMin * Math.pow(2.0, scale / that.options.zoomMin)
        else scale = 2.0 * that.options.zoomMax * Math.pow(0.5, that.options.zoomMax / scale)  if scale > that.options.zoomMax
        that.lastScale = scale / @scale
        newX = @originX - @originX * that.lastScale + @x
        newY = @originY - @originY * that.lastScale + @y

        @scroller.style[transform] = "translate(" + newX + "px," + newY + "px) scale(" + scale + ")" + translateZ
        that.options.onZoom.call that, e  if that.options.onZoom
        return
      that.pointX = point.pageX
      that.pointY = point.pageY
      newX = (if that.options.bounce then that.x + (deltaX / 2) else (if newX >= 0 or that.maxScrollX >= 0 then 0 else that.maxScrollX))  if newX > 0 or newX < that.maxScrollX
      newY = (if that.options.bounce then that.y + (deltaY / 2) else (if newY >= that.minScrollY or that.maxScrollY >= 0 then that.minScrollY else that.maxScrollY))  if newY > that.minScrollY or newY < that.maxScrollY
      that.distX += deltaX
      that.distY += deltaY
      that.absDistX = m.abs(that.distX)
      that.absDistY = m.abs(that.distY)
      return  if that.absDistX < 6 and that.absDistY < 6
      if that.options.lockDirection
        if that.absDistX > that.absDistY + 5
          newY = that.y
          deltaY = 0
        else if that.absDistY > that.absDistX + 5
          newX = that.x
          deltaX = 0
      that.moved = true
      that._pos newX, newY
      that.dirX = (if deltaX > 0 then -1 else (if deltaX < 0 then 1 else 0))
      that.dirY = (if deltaY > 0 then -1 else (if deltaY < 0 then 1 else 0))
      if timestamp - that.startTime > 300
        that.startTime = timestamp
        that.startX = that.x
        that.startY = that.y
      that.options.onScrollMove.call that, e  if that.options.onScrollMove

    _end: (e) ->
      return  if hasTouch and e.touches.length isnt 0
      that = this
      point = (if hasTouch then e.changedTouches[0] else e)
      target = undefined
      ev = undefined
      momentumX =
        dist: 0
        time: 0

      momentumY =
        dist: 0
        time: 0

      duration = (e.timeStamp or Date.now()) - that.startTime
      newPosX = that.x
      newPosY = that.y
      distX = undefined
      distY = undefined
      newDuration = undefined
      snap = undefined
      scale = undefined
      that._unbind MOVE_EV, window
      that._unbind END_EV, window
      that._unbind CANCEL_EV, window
      that.options.onBeforeScrollEnd.call that, e  if that.options.onBeforeScrollEnd
      if that.zoomed
        scale = that.scale * that.lastScale
        scale = Math.max(that.options.zoomMin, scale)
        scale = Math.min(that.options.zoomMax, scale)
        that.lastScale = scale / that.scale
        that.scale = scale
        that.x = that.originX - that.originX * that.lastScale + that.x
        that.y = that.originY - that.originY * that.lastScale + that.y
        that.scroller.style[transitionDuration] = "200ms"
        that.scroller.style[transform] = "translate(" + that.x + "px," + that.y + "px) scale(" + that.scale + ")" + translateZ
        that.zoomed = false
        that.refresh()
        that.options.onZoomEnd.call that, e  if that.options.onZoomEnd
        return
      unless that.moved
        if hasTouch
          if that.doubleTapTimer and that.options.zoom
            clearTimeout that.doubleTapTimer
            that.doubleTapTimer = null
            that.options.onZoomStart.call that, e  if that.options.onZoomStart
            that.zoom that.pointX, that.pointY, (if that.scale is 1 then that.options.doubleTapZoom else 1)
            if that.options.onZoomEnd
              setTimeout (->
                that.options.onZoomEnd.call that, e
              ), 200
          else if @options.handleClick
            that.doubleTapTimer = setTimeout(->
              that.doubleTapTimer = null
              target = point.target
              target = target.parentNode  until target.nodeType is 1
              if target.tagName isnt "SELECT" and target.tagName isnt "INPUT" and target.tagName isnt "TEXTAREA"
                ev = doc.createEvent("MouseEvents")
                ev.initMouseEvent "click", true, true, e.view, 1, point.screenX, point.screenY, point.clientX, point.clientY, e.ctrlKey, e.altKey, e.shiftKey, e.metaKey, 0, null
                ev._fake = true
                target.dispatchEvent ev
            , (if that.options.zoom then 250 else 0))
        that._resetPos 400
        that.options.onTouchEnd.call that, e  if that.options.onTouchEnd
        return
      if duration < 300 and that.options.momentum
        momentumX = (if newPosX then that._momentum(newPosX - that.startX, duration, -that.x, that.scrollerW - that.wrapperW + that.x, (if that.options.bounce then that.wrapperW else 0)) else momentumX)
        momentumY = (if newPosY then that._momentum(newPosY - that.startY, duration, -that.y, ((if that.maxScrollY < 0 then that.scrollerH - that.wrapperH + that.y - that.minScrollY else 0)), (if that.options.bounce then that.wrapperH else 0)) else momentumY)
        newPosX = that.x + momentumX.dist
        newPosY = that.y + momentumY.dist
        if (that.x > 0 and newPosX > 0) or (that.x < that.maxScrollX and newPosX < that.maxScrollX)
          momentumX =
            dist: 0
            time: 0
        if (that.y > that.minScrollY and newPosY > that.minScrollY) or (that.y < that.maxScrollY and newPosY < that.maxScrollY)
          momentumY =
            dist: 0
            time: 0
      if momentumX.dist or momentumY.dist
        newDuration = m.max(m.max(momentumX.time, momentumY.time), 10)
        if that.options.snap
          distX = newPosX - that.absStartX
          distY = newPosY - that.absStartY
          if m.abs(distX) < that.options.snapThreshold and m.abs(distY) < that.options.snapThreshold
            that.scrollTo that.absStartX, that.absStartY, 200
          else
            snap = that._snap(newPosX, newPosY)
            newPosX = snap.x
            newPosY = snap.y
            newDuration = m.max(snap.time, newDuration)
        that.scrollTo m.round(newPosX), m.round(newPosY), newDuration
        that.options.onTouchEnd.call that, e  if that.options.onTouchEnd
        return
      if that.options.snap
        distX = newPosX - that.absStartX
        distY = newPosY - that.absStartY
        unless m.abs(distX) < that.options.snapThreshold and m.abs(distY) < that.options.snapThreshold
          snap = that._snap(that.x, that.y)
          that.scrollTo snap.x, snap.y, snap.time  if snap.x isnt that.x or snap.y isnt that.y
        that.options.onTouchEnd.call that, e  if that.options.onTouchEnd
        return
      that._resetPos 200
      that.options.onTouchEnd.call that, e  if that.options.onTouchEnd

    _resetPos: (time) ->
      that = this
      resetX = (if that.x >= 0 then 0 else (if that.x < that.maxScrollX then that.maxScrollX else that.x))
      resetY = (if that.y >= that.minScrollY or that.maxScrollY > 0 then that.minScrollY else (if that.y < that.maxScrollY then that.maxScrollY else that.y))
      if resetX is that.x and resetY is that.y
        if that.moved
          that.moved = false
          that.options.onScrollEnd.call that  if that.options.onScrollEnd
        if that.hScrollbar and that.options.hideScrollbar
          that.hScrollbarWrapper.style[transitionDelay] = "300ms"  if vendor is "webkit"
          that.hScrollbarWrapper.style.opacity = "0"
        if that.vScrollbar and that.options.hideScrollbar
          that.vScrollbarWrapper.style[transitionDelay] = "300ms"  if vendor is "webkit"
          that.vScrollbarWrapper.style.opacity = "0"
        return
      that.scrollTo resetX, resetY, time or 0

    _wheel: (e) ->
      that = this
      wheelDeltaX = undefined
      wheelDeltaY = undefined
      deltaX = undefined
      deltaY = undefined
      deltaScale = undefined
      if "wheelDeltaX" of e
        wheelDeltaX = e.wheelDeltaX / 12
        wheelDeltaY = e.wheelDeltaY / 12
      else if "wheelDelta" of e
        wheelDeltaX = wheelDeltaY = e.wheelDelta / 12
      else if "detail" of e
        wheelDeltaX = wheelDeltaY = -e.detail * 3
      else
        return
      if that.options.wheelAction is "zoom"
        deltaScale = that.scale * Math.pow(2, 1 / 3 * ((if wheelDeltaY then wheelDeltaY / Math.abs(wheelDeltaY) else 0)))
        deltaScale = that.options.zoomMin  if deltaScale < that.options.zoomMin
        deltaScale = that.options.zoomMax  if deltaScale > that.options.zoomMax
        unless deltaScale is that.scale
          that.options.onZoomStart.call that, e  if not that.wheelZoomCount and that.options.onZoomStart
          that.wheelZoomCount++
          that.zoom e.pageX, e.pageY, deltaScale, 400
          setTimeout (->
            that.wheelZoomCount--
            that.options.onZoomEnd.call that, e  if not that.wheelZoomCount and that.options.onZoomEnd
          ), 400
        return
      deltaX = that.x + wheelDeltaX
      deltaY = that.y + wheelDeltaY
      if deltaX > 0
        deltaX = 0
      else deltaX = that.maxScrollX  if deltaX < that.maxScrollX
      if deltaY > that.minScrollY
        deltaY = that.minScrollY
      else deltaY = that.maxScrollY  if deltaY < that.maxScrollY
      that.scrollTo deltaX, deltaY, 0  if that.maxScrollY < 0

    _transitionEnd: (e) ->
      that = this
      return  unless e.target is that.scroller
      that._unbind TRNEND_EV
      that._startAni()

    _startAni: ->
      that = this
      startX = that.x
      startY = that.y
      startTime = Date.now()
      step = undefined
      easeOut = undefined
      animate = undefined
      return  if that.animating
      unless that.steps.length
        that._resetPos 400
        return
      step = that.steps.shift()
      step.time = 0  if step.x is startX and step.y is startY
      that.animating = true
      that.moved = true
      if that.options.useTransition
        that._transitionTime step.time
        that._pos step.x, step.y
        that.animating = false
        if step.time
          that._bind TRNEND_EV
        else
          that._resetPos 0
        return
      animate = ->
        now = Date.now()
        newX = undefined
        newY = undefined
        if now >= startTime + step.time
          that._pos step.x, step.y
          that.animating = false
          that.options.onAnimationEnd.call that  if that.options.onAnimationEnd
          that._startAni()
          return
        now = (now - startTime) / step.time - 1
        easeOut = m.sqrt(1 - now * now)
        newX = (step.x - startX) * easeOut + startX
        newY = (step.y - startY) * easeOut + startY
        that._pos newX, newY
        that.aniTime = nextFrame(animate)  if that.animating

      animate()

    _transitionTime: (time) ->
      time += "ms"
      @scroller.style[transitionDuration] = time
      @hScrollbarIndicator.style[transitionDuration] = time  if @hScrollbar
      @vScrollbarIndicator.style[transitionDuration] = time  if @vScrollbar

    _momentum: (dist, time, maxDistUpper, maxDistLower, size) ->
      deceleration = 0.0006
      speed = m.abs(dist) / time
      newDist = (speed * speed) / (2 * deceleration)
      newTime = 0
      outsideDist = 0
      if dist > 0 and newDist > maxDistUpper
        outsideDist = size / (6 / (newDist / speed * deceleration))
        maxDistUpper = maxDistUpper + outsideDist
        speed = speed * maxDistUpper / newDist
        newDist = maxDistUpper
      else if dist < 0 and newDist > maxDistLower
        outsideDist = size / (6 / (newDist / speed * deceleration))
        maxDistLower = maxDistLower + outsideDist
        speed = speed * maxDistLower / newDist
        newDist = maxDistLower
      newDist = newDist * ((if dist < 0 then -1 else 1))
      newTime = speed / deceleration
      dist: newDist
      time: m.round(newTime)

    _offset: (el) ->
      left = -el.offsetLeft
      top = -el.offsetTop
      while el = el.offsetParent
        left -= el.offsetLeft
        top -= el.offsetTop
      unless el is @wrapper
        left *= @scale
        top *= @scale
      left: left
      top: top

    _snap: (x, y) ->
      that = this
      i = undefined
      l = undefined
      page = undefined
      time = undefined
      sizeX = undefined
      sizeY = undefined
      page = that.pagesX.length - 1
      i = 0
      l = that.pagesX.length

      while i < l
        if x >= that.pagesX[i]
          page = i
          break
        i++
      page--  if page is that.currPageX and page > 0 and that.dirX < 0
      x = that.pagesX[page]
      sizeX = m.abs(x - that.pagesX[that.currPageX])
      sizeX = (if sizeX then m.abs(that.x - x) / sizeX * 500 else 0)
      that.currPageX = page
      page = that.pagesY.length - 1
      i = 0
      while i < page
        if y >= that.pagesY[i]
          page = i
          break
        i++
      page--  if page is that.currPageY and page > 0 and that.dirY < 0
      y = that.pagesY[page]
      sizeY = m.abs(y - that.pagesY[that.currPageY])
      sizeY = (if sizeY then m.abs(that.y - y) / sizeY * 500 else 0)
      that.currPageY = page
      time = m.round(m.max(sizeX, sizeY)) or 200
      x: x
      y: y
      time: time

    _bind: (type, el, bubble) ->
      (el or @scroller).addEventListener type, this, !!bubble

    _unbind: (type, el, bubble) ->
      (el or @scroller).removeEventListener type, this, !!bubble

    destroy: ->
      that = this
      that.scroller.style[transform] = ""
      that.hScrollbar = false
      that.vScrollbar = false
      that._scrollbar "h"
      that._scrollbar "v"
      that._unbind RESIZE_EV, window
      that._unbind START_EV
      that._unbind MOVE_EV, window
      that._unbind END_EV, window
      that._unbind CANCEL_EV, window
      that._unbind WHEEL_EV  unless that.options.hasTouch
      that._unbind TRNEND_EV  if that.options.useTransition
      clearInterval that.checkDOMTime  if that.options.checkDOMChanges
      that.options.onDestroy.call that  if that.options.onDestroy

    refresh: ->
      that = this
      offset = undefined
      i = undefined
      l = undefined
      els = undefined
      pos = 0
      page = 0
      that.scale = that.options.zoomMin  if that.scale < that.options.zoomMin
      that.wrapperW = that.wrapper.clientWidth or 1
      that.wrapperH = that.wrapper.clientHeight or 1
      that.minScrollY = -that.options.topOffset or 0
      that.scrollerW = m.round(that.scroller.offsetWidth * that.scale)
      that.scrollerH = m.round((that.scroller.offsetHeight + that.minScrollY) * that.scale)
      that.maxScrollX = that.wrapperW - that.scrollerW
      that.maxScrollY = that.wrapperH - that.scrollerH + that.minScrollY
      that.dirX = 0
      that.dirY = 0
      that.options.onRefresh.call that  if that.options.onRefresh
      that.hScroll = that.options.hScroll and that.maxScrollX < 0
      that.vScroll = that.options.vScroll and (not that.options.bounceLock and not that.hScroll or that.scrollerH > that.wrapperH)
      that.hScrollbar = that.hScroll and that.options.hScrollbar
      that.vScrollbar = that.vScroll and that.options.vScrollbar and that.scrollerH > that.wrapperH
      offset = that._offset(that.wrapper)
      that.wrapperOffsetLeft = -offset.left
      that.wrapperOffsetTop = -offset.top
      if typeof that.options.snap is "string"
        that.pagesX = []
        that.pagesY = []
        els = that.scroller.querySelectorAll(that.options.snap)
        i = 0
        l = els.length

        while i < l
          pos = that._offset(els[i])
          pos.left += that.wrapperOffsetLeft
          pos.top += that.wrapperOffsetTop
          that.pagesX[i] = (if pos.left < that.maxScrollX then that.maxScrollX else pos.left * that.scale)
          that.pagesY[i] = (if pos.top < that.maxScrollY then that.maxScrollY else pos.top * that.scale)
          i++
      else if that.options.snap
        that.pagesX = []
        while pos >= that.maxScrollX
          that.pagesX[page] = pos
          pos = pos - that.wrapperW
          page++
        that.pagesX[that.pagesX.length] = that.maxScrollX - that.pagesX[that.pagesX.length - 1] + that.pagesX[that.pagesX.length - 1]  if that.maxScrollX % that.wrapperW
        pos = 0
        page = 0
        that.pagesY = []
        while pos >= that.maxScrollY
          that.pagesY[page] = pos
          pos = pos - that.wrapperH
          page++
        that.pagesY[that.pagesY.length] = that.maxScrollY - that.pagesY[that.pagesY.length - 1] + that.pagesY[that.pagesY.length - 1]  if that.maxScrollY % that.wrapperH
      that._scrollbar "h"
      that._scrollbar "v"
      unless that.zoomed
        that.scroller.style[transitionDuration] = "0"
        that._resetPos 400

    scrollTo: (x, y, time, relative) ->
      that = this
      step = x
      i = undefined
      l = undefined
      that.stop()
      unless step.length
        step = [
          x: x
          y: y
          time: time
          relative: relative
        ]
      i = 0
      l = step.length

      while i < l
        if step[i].relative
          step[i].x = that.x - step[i].x
          step[i].y = that.y - step[i].y
        that.steps.push
          x: step[i].x
          y: step[i].y
          time: step[i].time or 0

        i++
      that._startAni()

    scrollToElement: (el, time) ->
      that = this
      pos = undefined
      el = (if el.nodeType then el else that.scroller.querySelector(el))
      return  unless el
      pos = that._offset(el)
      pos.left += that.wrapperOffsetLeft
      pos.top += that.wrapperOffsetTop
      pos.left = (if pos.left > 0 then 0 else (if pos.left < that.maxScrollX then that.maxScrollX else pos.left))
      pos.top = (if pos.top > that.minScrollY then that.minScrollY else (if pos.top < that.maxScrollY then that.maxScrollY else pos.top))
      time = (if time is `undefined` then m.max(m.abs(pos.left) * 2, m.abs(pos.top) * 2) else time)
      that.scrollTo pos.left, pos.top, time

    scrollToPage: (pageX, pageY, time) ->
      that = this
      x = undefined
      y = undefined
      time = (if time is `undefined` then 400 else time)
      that.options.onScrollStart.call that  if that.options.onScrollStart
      if that.options.snap
        pageX = (if pageX is "next" then that.currPageX + 1 else (if pageX is "prev" then that.currPageX - 1 else pageX))
        pageY = (if pageY is "next" then that.currPageY + 1 else (if pageY is "prev" then that.currPageY - 1 else pageY))
        pageX = (if pageX < 0 then 0 else (if pageX > that.pagesX.length - 1 then that.pagesX.length - 1 else pageX))
        pageY = (if pageY < 0 then 0 else (if pageY > that.pagesY.length - 1 then that.pagesY.length - 1 else pageY))
        that.currPageX = pageX
        that.currPageY = pageY
        x = that.pagesX[pageX]
        y = that.pagesY[pageY]
      else
        x = -that.wrapperW * pageX
        y = -that.wrapperH * pageY
        x = that.maxScrollX  if x < that.maxScrollX
        y = that.maxScrollY  if y < that.maxScrollY
      that.scrollTo x, y, time

    disable: ->
      @stop()
      @_resetPos 0
      @enabled = false
      @_unbind MOVE_EV, window
      @_unbind END_EV, window
      @_unbind CANCEL_EV, window

    enable: ->
      @enabled = true

    stop: ->
      if @options.useTransition
        @_unbind TRNEND_EV
      else
        cancelFrame @aniTime
      @steps = []
      @moved = false
      @animating = false

    zoom: (x, y, scale, time) ->
      that = this
      relScale = scale / that.scale
      return  unless that.options.useTransform
      that.zoomed = true
      time = (if time is `undefined` then 200 else time)
      x = x - that.wrapperOffsetLeft - that.x
      y = y - that.wrapperOffsetTop - that.y
      that.x = x - x * relScale + that.x
      that.y = y - y * relScale + that.y
      that.scale = scale
      that.refresh()
      that.x = (if that.x > 0 then 0 else (if that.x < that.maxScrollX then that.maxScrollX else that.x))
      that.y = (if that.y > that.minScrollY then that.minScrollY else (if that.y < that.maxScrollY then that.maxScrollY else that.y))
      that.scroller.style[transitionDuration] = time + "ms"
      that.scroller.style[transform] = "translate(" + that.x + "px," + that.y + "px) scale(" + scale + ")" + translateZ
      that.zoomed = false

    isReady: ->
      not @moved and not @zoomed and not @animating

  dummyStyle = null # for the sake of it
  if typeof exports isnt "undefined"
    exports.iScroll = iScroll
  else
    window.iScroll = iScroll
) window, document