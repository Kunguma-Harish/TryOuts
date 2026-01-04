var LibraryNWT = {
  $NWTApplicator: function (id, canvas, winPtr, share) {
    this.id = id;
    this.canvas = canvas;
    this.title = canvas.id;
    this.share = share;
    this.winPtr = winPtr;
    this.textEditorInput = document.getElementById(
      canvas.id + "TextEditorInput",
    );
    this.keys = new Array();
    this.domKeys = new Array();
    this.windowPosFunc = null;
    this.windowSizeFunc = null;
    this.windowCloseFunc = null;
    this.windowRefreshFunc = null;
    this.windowFocusFunc = null;
    this.windowIconifyFunc = null;
    this.framebufferResizeFunc = null;
    this.framebufferResizeEndFunc = null;
    this.contentScaleFunc = null;
    this.mouseButtonFunc = null;
    this.singleClickStartFunc = null;
    this.singleClickEndFunc = null;
    this.doubleClickStartFunc = null;
    this.doubleClickEndFunc = null;
    this.tripleClickStartFunc = null;
    this.tripleClickEndFunc = null;
    this.rightMouseDown = null;
    this.rightMouseup = null;
    this.keyDownFunc = null;
    this.keyUpFunc = null;
    this.cursorPosFunc = null;
    this.cursorEnterFunc = null;
    this.scrollFunc = null;
    this.pinchZoomFunc = null;
    this.dropFunc = null;
    this.dragFunc = null;
    this.textInputFunc = null;
    this.charFunc = null;
    this.userptr = null;
    this.startX = null;
    this.startY = null;
    this.prevX = null;
    this.prevY = null;
    this.currX = null;
    this.currY = null;
    this.holdTimer = null;
    this.longPressTimer = null;
    this.zoomTimer = null;
    this.scrollTimer = null;
    this.resizeTimer = null;
    this.scrollEndFunc = null;
    this.zoomEndFunc = null;
    this.overrideMouseWheelDefault = false;
    this.pixelR = window.devicePixelRatio;
    this.displayWidth=screen.width;
    this.displayHeight=screen.height;
    this.monitorResizedFunc=null;
    //original event properties
    this.keyPressed=null;
    this.modifierKeyPressed=null;
    this.populateCustomEvents=null;
    this.clearCustomEvents=null;
  },

  $WebEvents: class WebEvents {
    cursorPosFunc(currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.cursorPosFunc)(win.winPtr, currX, currY, modifier);
    }
    pinchZoomFunc(magnification, xPos, yPos, win, wasmTable) {
      wasmTable.get(win.pinchZoomFunc)(win.winPtr, magnification, xPos, yPos);
    }
    scrollFunc(xOffset, yOffset, xPos, yPos, modifier, win, wasmTable) {
      wasmTable.get(win.scrollFunc)(win.winPtr, xOffset, yOffset, xPos, yPos, modifier);
    }
    dragFunc(startX, startY, currX, currY, prevX, prevY, modifier, win, wasmTable) {
      wasmTable.get(win.dragFunc)(win.winPtr, startX, startY, currX, currY, prevX, prevY, modifier);
    }
    mouseHoldFunc(startX, startY, currX, currY, prevX, prevY, modifier, win, wasmTable) {
      wasmTable.get(win.mouseHoldFunc)(win.winPtr, startX, startY, currX, currY, prevX, prevY, modifier);
    }
    singleClickStartFunc(currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.singleClickStartFunc)(win.winPtr, currX, currY, modifier);
    }
    singleClickEndFunc(startX, startY, currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.singleClickEndFunc)(win.winPtr, startX, startY, currX, currY, modifier);
    }
    doubleClickStartFunc(currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.doubleClickStartFunc)(win.winPtr, currX, currY, modifier);
    }
    doubleClickEndFunc(startX, startY, currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.doubleClickEndFunc)(win.winPtr, startX, startY, currX, currY, modifier);
    }
    tripleClickStartFunc(currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.tripleClickStartFunc)(win.winPtr, currX, currY, modifier);
    }
    tripleClickEndFunc(startX, startY, currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.tripleClickEndFunc)(win.winPtr, startX, startY, currX, currY, modifier);
    }
    rightMouseDown(currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.rightMouseDown)(win.winPtr, currX, currY, modifier);
    }
    rightMouseUp(startX, startY, currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.rightMouseUp)(win.winPtr, startX, startY, currX, currY, modifier);
    }
    longPressFunc(currX, currY, modifier, win, wasmTable) {
      wasmTable.get(win.longPressFunc)(win.winPtr, currX, currY, modifier);
    }
    keyUpFunc(key, scancode, action, chars, win, wasmTable) {
      return wasmTable.get(win.keyUpFunc)(win.winPtr, key, scancode, action, chars);
    }
    onKeyDownEvent(key, scancode, action, chars, win, wasmTable) {
      return wasmTable.get(win.keyDownFunc)(win.winPtr, key, scancode, action, chars);
    }
    textInputFunc(text, length, win, wasmTable) {
      wasmTable.get(win.textInputFunc)(win.winPtr, text, length);
    }
    framebufferResizeFunc(canvasWidth, canvasHeight, modifier, win, wasmTable) {
      wasmTable.get(win.framebufferResizeFunc)(win.winPtr, canvasWidth, canvasHeight, modifier);
    }
    framebufferResizeEndFunc(canvasWidth, canvasHeight, modifier, win, wasmTable) {
      wasmTable.get(win.framebufferResizeEndFunc)(win.winPtr, canvasWidth, canvasHeight, modifier);
    }
    contentScaleFunc(x1, y1, modifier, win, wasmTable) {
      wasmTable.get(win.contentScaleFunc)(win.winPtr, x1, y1, modifier);
    }
    scrollEndFunc(xPos, yPos, win, wasmTable) {
      wasmTable.get(win.scrollEndFunc)(win.winPtr, xPos, yPos);
    }
    zoomEndFunc(win, wasmTable) {
      wasmTable.get(win.zoomEndFunc)(win.winPtr);
    }
  },

  $NativeWebViewEvents: class NativeWebViewEvents {
    cursorPosFunc(currX, currY, modifier) {
      NWT.webViewAppBinder?.onCursorPosChangeEvent(currX, currY, modifier);
    }
    pinchZoomFunc(magnification, xPos, yPos) {
      NWT.webViewAppBinder?.onPinchZoomEvent(magnification, xPos, yPos);
    }
    scrollFunc(xOffset, yOffset, xPos, yPos, modifier) {
      NWT.webViewAppBinder?.onScrollEvent(xOffset, yOffset, xPos, yPos, modifier);
    }
    dragFunc(startX, startY, currX, currY, prevX, prevY, modifier) {
      NWT.webViewAppBinder?.onMouseDragEvent(startX, startY, currX, currY, prevX, prevY, modifier);
    }
    mouseHoldFunc(startX, startY, currX, currY, prevX, prevY, modifier) {
      NWT.webViewAppBinder?.onMouseHoldEvent(startX, startY, currX, currY, prevX, prevY, modifier);
    }
    singleClickStartFunc(currX, currY, modifier) {
      NWT.webViewAppBinder?.onSingleClickStartEvent(currX, currY, modifier);
    }
    singleClickEndFunc(startX, startY, currX, currY, modifier) {
      NWT.webViewAppBinder?.onSingleClickEndEvent(startX, startY, currX, currY, modifier);
    }
    doubleClickStartFunc(currX, currY, modifier) {
      NWT.webViewAppBinder?.onDoubleClickStartEvent(currX, currY, modifier);
    }
    doubleClickEndFunc(startX, startY, currX, currY, modifier) {
      NWT.webViewAppBinder?.onDoubleClickEndEvent(startX, startY, currX, currY, modifier);
    }
    tripleClickStartFunc(currX, currY, modifier) {
      NWT.webViewAppBinder?.onTripleClickStartEvent(currX, currY, modifier);
    }
    tripleClickEndFunc(startX, startY, currX, currY, modifier) {
      NWT.webViewAppBinder?.onTripleClickEndEvent(startX, startY, currX, currY, modifier);
    }
    rightMouseDown(currX, currY, modifier) {
      NWT.webViewAppBinder?.onRightMouseDownEvent(currX, currY, modifier);
    }
    rightMouseUp(startX, startY, currX, currY, modifier) {
      NWT.webViewAppBinder?.onRightMouseUpEvent(startX, startY, currX, currY, modifier);
    }
    longPressFunc(currX, currY, modifier) {
      NWT.webViewAppBinder?.onLongPressEvent(currX, currY, modifier);
    }
    keyUpFunc(key, scancode, action, chars) {
      return NWT.webViewAppBinder?.onKeyUpEvent(key, scancode, action, chars);
    }
    onKeyDownEvent(key, scancode, action, chars) {
      return NWT.webViewAppBinder?.onKeyDownEvent(key, scancode, action, chars);
    }
    textInputFunc(text, length) {
      NWT.webViewAppBinder?.onTextInputEvent(text, length);
    }
    framebufferResizeFunc(canvasWidth, canvasHeight, modifier) {
      NWT.webViewAppBinder?.onFrameBufferResizeEvent(canvasWidth, canvasHeight);
    }
    framebufferResizeEndFunc(canvasWidth, canvasHeight, modifier) {
      NWT.webViewAppBinder?.onFrameBufferResizeEndEvent(canvasWidth, canvasHeight, modifier);
    }
    contentScaleFunc(x1, y1, modifier) {
      NWT.webViewAppBinder?.onContentScaleChangeEvent(x1, y1, modifier);
    }
    scrollEndFunc(xPos, yPos) {
      NWT.webViewAppBinder?.onScrollEndEvent(xPos, yPos);
    }
    zoomEndFunc() {
      NWT.webViewAppBinder?.onPinchZoomEndEvent();
    }
  },

  $NWT__deps: ["emscripten_get_now", "$NWTApplicator", "$Browser", "$WebEvents", "$NativeWebViewEvents"], //No I18N
  $NWT: {
    windows: {},
    winPtrMap: {},
    lastActive: null,
    winChangeFunc: null,
    registeredEvents: [],
    eventHandler: null,
    isWebView: false,
    webViewAppBinder: null,

    addWindow: function (win) {
      NWT.winPtrMap[win.winPtr] = win.title;
      NWT.windows[win.title] = win;
    },

    getWindowFromPtr: function (winPtr) {
      let winHandle = NWT.winPtrMap[winPtr];
      return NWT.windows[winHandle];
    },

    addNWTvent: function (_target, _eventName, fn, b) {
      _target.addEventListener(_eventName, fn, b);
      NWT.registeredEvents.push({ target: _target, eventName: _eventName, callback: fn });

    },

    setCallbackOnWindow: function (winPtr, callbackName, callback) {
      let win = NWT.getWindowFromPtr(winPtr);
      if (win !== undefined) {
        win[callbackName] = callback;
      }
    },

    //Util based functions
    DOMToNWTKeyCode: function (keycode) {
      switch (keycode) {
        case 32:
          return 32;
        case 222:
          return 39;
        case 188:
          return 44;
        case 173:
          return 45;
        case 189:
          return 45;
        case 190:
          return 46;
        case 191:
          return 47;
        case 48:
          return 48;
        case 49:
          return 49;
        case 50:
          return 50;
        case 51:
          return 51;
        case 52:
          return 52;
        case 53:
          return 53;
        case 54:
          return 54;
        case 55:
          return 55;
        case 56:
          return 56;
        case 57:
          return 57;
        case 59:
          return 59;
        case 61:
          return 61;
        case 187:
          return 61;
        case 65:
          return 65;
        case 66:
          return 66;
        case 67:
          return 67;
        case 68:
          return 68;
        case 69:
          return 69;
        case 70:
          return 70;
        case 71:
          return 71;
        case 72:
          return 72;
        case 73:
          return 73;
        case 74:
          return 74;
        case 75:
          return 75;
        case 76:
          return 76;
        case 77:
          return 77;
        case 78:
          return 78;
        case 79:
          return 79;
        case 80:
          return 80;
        case 81:
          return 81;
        case 82:
          return 82;
        case 83:
          return 83;
        case 84:
          return 84;
        case 85:
          return 85;
        case 86:
          return 86;
        case 87:
          return 87;
        case 88:
          return 88;
        case 89:
          return 89;
        case 90:
          return 90;
        case 219:
          return 91;
        case 220:
          return 92;
        case 221:
          return 93;
        case 192:
          return 94;
        case 27:
          return 256;
        case 13:
          return 257;
        case 9:
          return 258;
        case 8:
          return 259;
        case 45:
          return 260;
        case 46:
          return 261;
        case 39:
          return 262;
        case 37:
          return 263;
        case 40:
          return 264;
        case 38:
          return 265;
        case 33:
          return 266;
        case 34:
          return 267;
        case 36:
          return 268;
        case 35:
          return 269;
        case 20:
          return 280;
        case 145:
          return 281;
        case 144:
          return 282;
        case 44:
          return 283;
        case 19:
          return 284;
        case 112:
          return 290;
        case 113:
          return 291;
        case 114:
          return 292;
        case 115:
          return 293;
        case 116:
          return 294;
        case 117:
          return 295;
        case 118:
          return 296;
        case 119:
          return 297;
        case 120:
          return 298;
        case 121:
          return 299;
        case 122:
          return 300;
        case 123:
          return 301;
        case 124:
          return 302;
        case 125:
          return 303;
        case 126:
          return 304;
        case 127:
          return 305;
        case 128:
          return 306;
        case 129:
          return 307;
        case 130:
          return 308;
        case 131:
          return 309;
        case 132:
          return 310;
        case 133:
          return 311;
        case 134:
          return 312;
        case 135:
          return 313;
        case 136:
          return 314;
        case 96:
          return 320;
        case 97:
          return 321;
        case 98:
          return 322;
        case 99:
          return 323;
        case 100:
          return 324;
        case 101:
          return 325;
        case 102:
          return 326;
        case 103:
          return 327;
        case 104:
          return 328;
        case 105:
          return 329;
        case 110:
          return 330;
        case 111:
          return 331;
        case 106:
          return 332;
        case 109:
          return 333;
        case 107:
          return 334;
        case 16:
          return 340;
        case 17:
          return 341;
        case 18:
          return 342;
        case 91:
          return 343;
        case 93:
          return 348;
        default:
          return -1;
      }
    },

    DOMToNWTMouseButton: function (event) {
      var eventButton = event.button;
      if (eventButton > 0) {
        if (eventButton == 1) {
          eventButton = 2;
        } else {
          eventButton = 1;
        }
      }
      return eventButton;
    },

    getModBits: function (win) {
      var mod = 0;
      if (win.keys[340]) {
        mod |= 1;
      }
      if (win.keys[341]) {
        mod |= 2;
      }
      if (win.keys[342]) {
        mod |= 4;
      }
      if (win.keys[343]) {
        mod |= 8;
      }
      return mod;
    },

    getModifierValue: function (event) {
      const MODIFIERS = {
        SHIFT: 1,
        CTRL_NON_MAC: 8,
        CTRL_MAC: 2,
        ALT: 4,
        META: 8,
        SPACE: 64
      };

      const KEYCODES = {
          SHIFT: 16,
          CTRL: 17,
          ALT: 18,
          SPACE: 32,
          META_LEFT: 91,
          META_RIGHT: 92
      };

      let mod = 0;
      const isMac = navigator.userAgent.includes('Mac');//No i18n
      const pressedKey = NWT.keyPressed;

      if (event.shiftKey || pressedKey === KEYCODES.SHIFT) {
          mod |= MODIFIERS.SHIFT;
      }

      if (event.ctrlKey || pressedKey === KEYCODES.CTRL) {
          mod |= isMac ? MODIFIERS.CTRL_MAC : MODIFIERS.CTRL_NON_MAC;
      }

      if (event.altKey || pressedKey === KEYCODES.ALT) {
          mod |= MODIFIERS.ALT;
      }

      if (event.metaKey || pressedKey === KEYCODES.META_LEFT || pressedKey === KEYCODES.META_RIGHT) {
          mod |= MODIFIERS.META;
      }

      if (pressedKey === KEYCODES.SPACE) {
          mod |= MODIFIERS.SPACE;
      }

      return mod;
    },


    isWindowTargeted: function (target) {
      if (target) {
        if (
          target.isContentEditable ||
          target.tagName == "INPUT" ||
          target.tagName == "TEXTAREA"
        ) {
          return false;
        }
      }
      return true;
    },

    getCurrentTime: function () {
      return _emscripten_get_now() / 1000;
    },

    //Functions for capturing events
    onKeyDown: function (event) {
      let action = 2;
      if (event.repeat) {
        action = 2;
      } else {
        action = 1;
      }
      var windowId = event.target.id.endsWith("TextEditorInput")
        ? event.target.getAttribute("canvasId")
        : event.target.id; //No i18n
      var win = NWT.windows[windowId];
      if (!win) { return; }
      if (!(win.textEditorInput != undefined && document.activeElement == win.textEditorInput)) {
        win.canvas.focus();
      }
      let keyCode = event.keyCode;
      NWT.keyPressed = keyCode;
      NWT.modifierKeyPressed = NWT.getModifierValue(event);
      var key = NWT.DOMToNWTKeyCode(keyCode);
      

      if (key == -1) {
        return;
      }
      if (!win.keyDownFunc) { return; }
      var keyProcessed = NWT.eventHandler.onKeyDownEvent(key, action, NWT.modifierKeyPressed, stringToUTF8OnStack(event.key), win, wasmTable);
      if (keyProcessed) {
        event.stopPropagation();
        event.preventDefault();
      }
    },

    onKeyUp: function (event) {
      var windowId = event.target.id.endsWith("TextEditorInput")
        ? event.target.getAttribute("canvasId")
        : event.target.id; //No i18n
      var win = NWT.windows[windowId];
      if (!win) { return; }
      NWT.keyPressed = null;
      let keyCode = event.keyCode;
      NWT.modifierKeyPressed = NWT.getModifierValue(event);
      var key = NWT.DOMToNWTKeyCode(keyCode);
      if (key == -1) {
        return;
      }

      if (!win.keyUpFunc) { return; }
      var keyProcessed = NWT.eventHandler.keyUpFunc(key, 0, NWT.modifierKeyPressed, stringToUTF8OnStack(event.key), win, wasmTable);
      if (keyProcessed) {
        event.stopPropagation();
        event.preventDefault();
      }
    },

    onTextInput: function (event) {
      var win = NWT.windows[event.target.getAttribute("canvasId")];
      if (!(win && win.textInputFunc)) {
        return;
      }
      if (event.constructor.name == "InputEvent") {
        if (event.inputType == "insertText") {
          // no i18n
          NWT.eventHandler.textInputFunc(stringToUTF8OnStack(event.data), -1, win, wasmTable);
          event.preventDefault();
        }
      } else if (event.constructor.name == "CompositionEvent") {
        var compositionStatus = -1;
        switch (event.type) {
          case "compositionstart":
            compositionStatus = 0;
            break;
          case "compositionupdate":
            compositionStatus = 1;
            break;
          case "compositionend":
            compositionStatus = 2;
            break;
          default:
            break;
        }
        NWT.eventHandler.textInputFunc(stringToUTF8OnStack(event.data), compositionStatus, win, wasmTable);
        event.preventDefault();
      }
    },

    onMouseDown: function (event) {
      var win = NWT.windows[event.target.id];
      if (!win) return;
      if (!(win.textEditorInput != undefined && document.activeElement == win.textEditorInput)) {
        win.canvas.focus();
      }
      clearTimeout(NWT.holdTimer);
      clearTimeout(NWT.longPressTimer);
      Browser.calculateMouseEvent(event);

      NWT.currX = Math.round(Browser.mouseX / window.devicePixelRatio);
      NWT.currY = Math.round(Browser.mouseY / window.devicePixelRatio);

      NWT.startX = NWT.currX;
      NWT.startY = NWT.currY;
      NWT.prevX = NWT.currX;
      NWT.prevY = NWT.currY;
      NWT.modifierKeyPressed =  NWT.getModifierValue(event);



      if (event.button === 2) {
        if (!win.rightMouseDown) return;
        NWT.isMouseDown = true;
        NWT.eventHandler.rightMouseDown(NWT.currX, NWT.currY, NWT.modifierKeyPressed, win, wasmTable);
      } else {
        switch (event.detail) {
          case 1:
            NWT.eventHandler.singleClickStartFunc(NWT.currX, NWT.currY, NWT.modifierKeyPressed, win, wasmTable);
            NWT.isMouseDown = true;
            break;
          case 2:
            NWT.eventHandler.doubleClickStartFunc(NWT.currX, NWT.currY, NWT.modifierKeyPressed, win, wasmTable);
            NWT.isMouseDown = true;
            break;
          case 3:
            NWT.eventHandler.tripleClickStartFunc(NWT.currX, NWT.currY, NWT.modifierKeyPressed, win, wasmTable);
            NWT.isMouseDown = true;
            break;
          default:
            return;
        }

        NWT.startMouseHold(win);

        NWT.longPressTimer = setInterval(function () {
          if (NWT.isMouseDown) {
            var longPressEvent = new CustomEvent('longPress'); // no i18n
            win.canvas.dispatchEvent(longPressEvent);
          }
        }, 320);
      }
    },

    //drag and cursor callback
    onMouseMove: function (event) {
      NWT.isMouseDrag = NWT.isMouseDown; // to identify drag

      var win = NWT.windows[event.target.id];
      // event gets interruputed due to ui elments present in the document
      if (!win) {
        if (!NWT.isMouseDrag) { return; }
        win = NWT.lastActive;
      }

      if (Module.canvas.id != win.canvas.id) {
        NWT.changeWindow(NWT.lastActive, win);
      }

      NWT.lastActive = win;


      Browser.calculateMouseEvent(event);
      NWT.currX = Math.round(Browser.mouseX / window.devicePixelRatio);
      NWT.currY = Math.round(Browser.mouseY / window.devicePixelRatio);

      if (NWT.isMouseDrag) {
        if (NWT.currX == NWT.prevX && NWT.currY == NWT.prevY) { return; } // to stop propagating drag when cursor is at the same point
        if (!(win && win.dragFunc)) { return; }
        if (!(win && win.dragFunc)) {
          return;
        }
        NWT.eventHandler.dragFunc(NWT.startX, NWT.startY, NWT.currX, NWT.currY, NWT.prevX, NWT.prevY, NWT.getModifierValue(event), win, wasmTable);
        NWT.prevX = NWT.currX;
        NWT.prevY = NWT.currY;
      } else {
        if (!(win && win.cursorPosFunc)) {
          return;
        }
        NWT.eventHandler.cursorPosFunc(NWT.currX, NWT.currY, NWT.getModifierValue(event), win, wasmTable);
      }
    },

    onMouseUp: function (event) {
      var win = NWT.windows[event.target.id];
      if (!win) {
        // check - mouse drag ends in document element.
        if (!NWT.isMouseDrag && !NWT.isMouseDown) { return; }
        win = NWT.lastActive;
      };

      Browser.calculateMouseEvent(event);
      NWT.currX = Math.round(Browser.mouseX / window.devicePixelRatio);
      NWT.currY = Math.round(Browser.mouseY / window.devicePixelRatio);
      NWT.prevX = 0.0;
      NWT.prevY = 0.0;
      NWT.modifierKeyPressed =  NWT.getModifierValue(event);

      if (event.button === 2) {
        if (!win.rightMouseUp) return;
        NWT.eventHandler.rightMouseUp(NWT.startX, NWT.startY, NWT.currX, NWT.currY, NWT.modifierKeyPressed, win, wasmTable);
      } else {
        switch (event.detail) {
          case 1:
            NWT.eventHandler.singleClickEndFunc(NWT.startX, NWT.startY, NWT.currX, NWT.currY, NWT.modifierKeyPressed, win, wasmTable);
            break;
          case 2:
            NWT.eventHandler.doubleClickEndFunc(NWT.startX, NWT.startY, NWT.currX, NWT.currY, NWT.modifierKeyPressed, win, wasmTable);
            break;
          case 3:
            NWT.eventHandler.tripleClickEndFunc(NWT.startX, NWT.startY, NWT.currX, NWT.currY, NWT.modifierKeyPressed, win, wasmTable);
            break;
          default:
            return;
        }
      }

      NWT.isMouseDown = false;
      NWT.isMouseDrag = false;
      NWT.stopMouseHold(win);
      clearInterval(NWT.longPressTimer);
    },

    onMouseHold: function (event) {
      var win = NWT.windows[event.target.id];
      if (!(win && win.mouseHoldFunc && win.populateCustomEvents)) { return; }
      // calls custom event propogator with customFun Id as 1 , with all required args
      // Unable to pass as HEAP32 : must confide with nexus.
      wasmTable.get(win.populateCustomEvents)(win.winPtr,1, NWT.startX, NWT.startY, NWT.currX, NWT.currY, NWT.prevX, NWT.prevY, NWT.modifierKeyPressed);

    
    },

    onLongPress: function (event) {
      var win = NWT.windows[event.target.id];
      if (!(win && win.longPressFunc)) { return; }

      Browser.calculateMouseEvent(event);
      NWT.eventHandler.longPressFunc(NWT.currX, NWT.currY, NWT.getModifierValue(event), win, wasmTable);

      clearInterval(NWT.longPressTimer);

    },

    onMouseWheel: function (event, _targetId) {
      if (window.visualViewport?.scale > 1) { return; } //to prevent canvas mouse-wheel when the document/window is zoomed
    
      var targetId = _targetId || event.target.id;
      var win = NWT.windows[targetId];
      if (!win) { return; }
      NWT.lastActive = win;
      var delta = -Browser.getMouseWheelDelta(event);
      delta = delta == 0 ? 0 : delta > 0 ? Math.max(delta, 1) : Math.min(delta, -1);
      NWT.wheelPos += delta;

      if (event.ctrlKey || event.metaKey) {
        event.preventDefault();
        event.stopImmediatePropagation();
        if (NWT.overrideMouseWheelDefault) {
          NWT.handleScroll(event, win);
        } else {
          NWT.handleZoom(event, win);

        }
      } else {
        if (NWT.overrideMouseWheelDefault) {
          NWT.handleZoom(event, win);
        } else {

          NWT.handleScroll(event, win);
        }
      }
    },

    onWebGLContextLost: function (event) {
      var custom_event = new CustomEvent("context_lost", { // no i18n
        detail: event,
        bubbles: true,
        cancelable: true
      });
      event.preventDefault();
      event.target.dispatchEvent(custom_event);
    },

    onWebGLContextRestored: function (event) {
      var custom_event = new CustomEvent("context_restored", { // no i18n
        detail: event,
        bubbles: true,
        cancelable: true
      });
      event.preventDefault();
      event.target.dispatchEvent(custom_event);
      event.target.removeEventListener(event.type, NWT.onWebGLContextRestored);
    },

    handleZoom: function (event, win) {
      if (!(win && win.pinchZoomFunc)) {
        return;
      }
      Browser.calculateMouseEvent(event);
      NWT.currX = Math.round(Browser.mouseX / window.devicePixelRatio);
      NWT.currY = Math.round(Browser.mouseY / window.devicePixelRatio);

      let isHandled = NWT.eventHandler.pinchZoomFunc(-event.deltaY / 100, NWT.currX, NWT.currY, win, wasmTable);
      clearTimeout(NWT.zoomTimer);
      if(isHandled){
        NWT.zoomTimer = setTimeout(function () {
          if (win.zoomEndFunc) {
            NWT.eventHandler.zoomEndFunc(win, wasmTable);
          }
        }, 70);

        event.stopPropagation();
        event.preventDefault();
      }
    },

    handleScroll: function (event, win) {
      if (!(win && win.scrollFunc)) {
        return;
      }

      var sx = 0;
      var sy = 0;
      var modifierKeyPressed = NWT.getModifierValue(event);
      if (event.type == "mousewheel") {
        sx = -event.wheelDeltaX;
        sy = -event.wheelDeltaY;
      } else {
        sx = event.deltaX;
        sy = event.deltaY;
      }
      Browser.calculateMouseEvent(event);
      NWT.currX = Math.round(Browser.mouseX / window.devicePixelRatio);
      NWT.currY = Math.round(Browser.mouseY / window.devicePixelRatio);

      let isHandled =  NWT.eventHandler.scrollFunc(-sx, -sy, NWT.currX, NWT.currY, NWT.getModifierValue(event), win, wasmTable);
      clearTimeout(NWT.scrollTimer);
      if(isHandled){
        event.preventDefault();
        event.stopPropagation();
        NWT.scrollTimer = setTimeout(function () {
          if (win.scrollEndFunc) {
            if (modifierKeyPressed == 8) {
              if (win.zoomEndFunc) {
                NWT.eventHandler.zoomEndFunc(win, wasmTable);
              }
            }
            Browser.calculateMouseEvent(event);
            NWT.currX = Math.round(Browser.mouseX / window.devicePixelRatio);
            NWT.currY = Math.round(Browser.mouseY / window.devicePixelRatio);
            NWT.eventHandler.scrollEndFunc(NWT.currX, NWT.currY, win, wasmTable);
          }
        }, 70);
      }
    },

    startMouseHold : function (win) {
      if (!NWT.holdTimer) {
        NWT.handleMouseHold(win, NWT);
      }
    },
    
    stopMouseHold : function (win) {
      cancelAnimationFrame(NWT.holdTimer);
      NWT.holdTimer = null;
      if (!win.clearCustomEvents){
        return;
      }
      wasmTable.get(win.clearCustomEvents)(win.winPtr);
    },

    handleMouseHold : function (win) {
      if (NWT.isMouseDown) {
        var mouseHoldEvent = new CustomEvent('mousehold'); // no i18n
        win.canvas.dispatchEvent(mouseHoldEvent);
        NWT.holdTimer = requestAnimationFrame(() => NWT.handleMouseHold(win)); 
      }
    },


    onFrameBufferResize: function (event) {
      if (!event) {
        return;
      }
      var win =
        NWT.windows[typeof event === "string" ? event : event.target.id]; // no i18n
      if (!(win && win.framebufferResizeFunc)) {
        return;
      }
      let canvas = win.canvas;
      let rect = canvas.getBoundingClientRect();
      
 

      NWT.eventHandler.framebufferResizeFunc(canvas.width, canvas.height, NWT.getModifierValue(event), win, wasmTable);
    },

    onFrameBufferResizeEnd: function (event) {
      if (!event) { return; }
      var win =
        NWT.windows[typeof event === "string" ? event : event.target.id]; // no i18n
      if (!(win && win.framebufferResizeEndFunc)) { return; }
      let canvas = win.canvas;
      NWT.eventHandler.framebufferResizeEndFunc(canvas.width, canvas.height, NWT.getModifierValue(event), win, wasmTable);
    },

    onContentScaleChange: function (event) {
      if (!event) {
        return;
      }
      var win =
        NWT.windows[typeof event === "string" ? event : event.target.id]; // no i18n
      if (!(win && win.contentScaleFunc)) {
        return;
      }
      let canvas = win.canvas;
      let dpr = window.devicePixelRatio;
      NWT.eventHandler.contentScaleFunc(dpr, dpr, NWT.getModifierValue(event), win, wasmTable);
    },

    changeWindow: function (oldwin, newwin) {
      if (newwin && newwin.canvas) {
        Module.canvas = newwin.canvas;
        if (NWT.winChangeFunc) {
          wasmTable.get(NWT.winChangeFunc)(newwin.winPtr);
        }
      }
    },

    onDisplayChanged: function (event) {
      if (NWT.pixelR != window.devicePixelRatio) {
        for (var title in NWT.winPtrMap) {
          if (NWT.winPtrMap.hasOwnProperty(title)) {
            var winTitle = NWT.winPtrMap[title];
            var win = NWT.windows[winTitle];
            if (!(win && win.contentScaleFunc)) { return; }
            wasmTable.get(win.contentScaleFunc)(win.winPtr, window.devicePixelRatio, window.devicePixelRatio);
            NWT.pixelR = window.devicePixelRatio;
          }
        }
      }
      if (NWT.displayWidth != screen.width && NWT.displayHeight != screen.height) {
        var win = NWT.windows[event.target.id];
        for (var title in NWT.winPtrMap) {
          if (NWT.winPtrMap.hasOwnProperty(title)) {
            var winTitle = NWT.winPtrMap[title];
            var win = NWT.windows[winTitle];
            if (!(win && win.monitorResizedFunc)) { return; }
            wasmTable.get(win.monitorResizedFunc)(win.winPtr, screen.width, screen.height);
            NWT.displayWidth = screen.width;
            NWT.displayHeight = screen.height;
          }
        }
      }
    },

    handlePinchZoom: function (event) {
      if (!NWT.isZooming && event.touches.length > 0) {
        NWT.currentTouchX = event.touches[0].clientX;
        NWT.currentTouchY = event.touches[0].clientY;
      }
      if (event.touches.length === 2) {
        const dx = event.touches[0].clientX - event.touches[1].clientX;
        const dy = event.touches[0].clientY - event.touches[1].clientY;
        const newDistance = Math.sqrt(dx * dx + dy * dy);
        NWT.currentTouchX = (event.touches[0].clientX + event.touches[1].clientX) / 2;
        NWT.currentTouchY = (event.touches[0].clientY + event.touches[1].clientY) / 2;

        if (NWT.initialDistance == 0) { return; }
        const zoomFactor = (newDistance - NWT.initialDistance) / NWT.initialDistance;



        var win = NWT.windows[NWT.title];
        if (win && win.pinchZoomFunc) {
          wasmTable.get(win.pinchZoomFunc)(win.winPtr, zoomFactor / 10, NWT.currentTouchX, NWT.currentTouchY);
        }

        if(isHandled){
          // Prevent default behavior
            event.stopPropagation();
            event.preventDefault();
        }
      } else if (event.touches.length === 1) {
        if (!NWT.propogateScroll) { return; }

        const scrollX = window.scrollX || 0;
        const scrollY = window.scrollY || 0;

        const deltaX = event.touches[0].clientX - NWT.currentTouchX;
        const deltaY = event.touches[0].clientY - NWT.currentTouchY;


        NWT.currentTouchX = event.touches[0].clientX;
        NWT.currentTouchY = event.touches[0].clientY;

        if (event.type === "scroll") {
          targetId = NWT.title;
        }
        var win = NWT.windows[NWT.title];
        if (!win) { return; }

        NWT.lastActive = win;
        if (!(win && win.scrollFunc)) {
          return;
        }
        let isHandled = wasmTable.get(win.scrollFunc)(win.winPtr, deltaX, deltaY, NWT.currentTouchX, NWT.currentTouchY, 0);
          if(isHandled){
          event.preventDefault();
            event.stopPropagation();
          }
      }
    },
    handleTouchEnd: function (event) {
      NWT.propogateScroll = false;
      NWT.initialDistance = 0;
      if (event.touches.length > 0) {
        NWT.currentTouchX = event.touches[0].clientX;
        NWT.currentTouchY = event.touches[0].clientY;
      }
      NWT.lastScrollX = window.scrollX || 0;
      NWT.lastScrollY = window.scrollY || 0;
      NWT.isZooming = false;
    },

    handleTouchStart: function (event) {
      NWT.propogateScroll = true;
      NWT.isZooming = true;
      if (event.touches.length > 0) {
        NWT.currentTouchX = event.touches[0].clientX;
        NWT.currentTouchY = event.touches[0].clientY;
      }
      NWT.lastScrollX = window.scrollX || 0;
      NWT.lastScrollY = window.scrollY || 0;

      if (event.touches.length === 2) {
        const dx = event.touches[0].clientX - event.touches[1].clientX;
        const dy = event.touches[0].clientY - event.touches[1].clientY;
        NWT.initialDistance = Math.sqrt(dx * dx + dy * dy);
      }
    },

    handleMouseMove: function (event) {
      if (!NWT.isZooming && event.touches.length > 0) {
        NWT.currentTouchX = event.touches[0].clientX;
        NWT.currentTouchY = event.touches[0].clientY;
      }
    },

    releaseEventProps:function() {
      NWT.keyPressed = null;
    }

  },


  //Functions to set callbacks
  initEventListener: function (winHandle, winPtr) {
    let canvas = findCanvasEventTarget(winHandle);
    if (!canvas) {
      return;
    }
    let winId = Object.keys(NWT.windows).length + 1;
    var win = new NWTApplicator(winId, canvas, winPtr, null);

    if (NWT.isWebView) {
      NWT.eventHandler = new NativeWebViewEvents();
    } else {
      NWT.eventHandler = new WebEvents();
    }
    NWT.addWindow(win);
    NWT.title = canvas.id;
    return winId;
  },

  setOnWindowChange: function (winPtr, callback) {
    NWT.winChangeFunc = callback;
  },

  htmlBindEventListeners: function (winPtr) {
    let win = NWT.getWindowFromPtr(winPtr);
    if (win != undefined) {
      let canvas = win.canvas;

      const DeviceDetector = {
        //Ua check : will fail for ipad air and ipad pro browser emulator
        isMobileUA: () => /Mobi|Android|iPhone|iPad|iPod|IEMobile|Opera Mini/i.test(navigator.userAgent),
        
        hasTouchSupport: () => 'ontouchstart' in window, //No i18n
        
        isRealMobileDevice: function() {
          return this.isMobileUA() && 
                 this.hasTouchSupport() && 
                 navigator.maxTouchPoints > 1;
        },
        
        isEmulator: function() {
          return this.isMobileUA() && 
                 this.hasTouchSupport() && 
                 navigator.maxTouchPoints === 1;
        }
      };
    
    if (DeviceDetector.isRealMobileDevice() && !DeviceDetector.isEmulator()) { // actual mobile browsers and to prevent browser emulators that do not support touch gestures
        // mobile-specific code here

        NWT.addNWTvent(window, "resize", NWT.onDisplayChanged, true); //No i18n
        NWT.addNWTvent(canvas, "webglcontextlost", NWT.onWebGLContextLost, true); //No i18n
        NWT.addNWTvent(canvas, "webglcontextrestored", NWT.onWebGLContextRestored, true); //No i18n
        window.addEventListener('touchmove', NWT.handlePinchZoom, { passive: false });
        canvas.addEventListener('touchend', NWT.handleTouchEnd);
        // window.addEventListener('touchcancel', resetZoom);
        // window.addEventListener('touchmove', handleMouseMove, { passive: true });
        canvas.addEventListener('touchstart', NWT.handleTouchStart, { passive: true });// No i18n
        //for mobile device
        // NWT.addNWTvent(window, "devicemotion", NWT.onDisplayChanged, true); //No i18n
        // NWT.addNWTvent(window, "deviceorientation", NWT.onDisplayChanged, true); //No i18n
      } else {
        // browser and emulators specific code here

        //mouse-up/down events
        NWT.addNWTvent(document, "mouseup", NWT.onMouseUp, true); //No i18n
        NWT.addNWTvent(canvas, "mousedown", NWT.onMouseDown, true); //No i18n

        // //mouse-move events
        NWT.addNWTvent(document, "mousemove", NWT.onMouseMove, true); //No i18n

        //scroll callbacks
        NWT.addNWTvent(canvas, "mousewheel", NWT.onMouseWheel, true); //No i18n
        NWT.addNWTvent(canvas, "wheel", NWT.onMouseWheel, true); //No i18n

        //key-up/down callbacks (need to set it to window)
        NWT.addNWTvent(window, "keydown", NWT.onKeyDown, true); //No i18n
        NWT.addNWTvent(window, "keyup", NWT.onKeyUp, true); //No i18n
        NWT.addNWTvent(window, "keyPress", NWT.onKeyPress, true); //No i18n

        // // context events
        NWT.addNWTvent(canvas, "webglcontextlost", NWT.onWebGLContextLost, true); //No i18n
        NWT.addNWTvent(canvas, "webglcontextrestored", NWT.onWebGLContextRestored, true); //No i18n

        //contentscale callback
        let pr = window.devicePixelRatio;
        matchMedia(`(resolution: ${pr}dppx)`).addEventListener(
          "change",                                            // no i18n
          () => NWT.onContentScaleChange(win.canvas.id),
          { once: false },
        );

        //frame buffer resize callback
        let resizeObserver = new ResizeObserver((entries) => {
          clearTimeout(NWT.resizeTimer);
          for (let entry in entries) {
            NWT.onFrameBufferResize(win.canvas.id);
          }
          NWT.resizeTimer = setTimeout(() => {
            NWT.onFrameBufferResizeEnd(win.canvas.id);
          }, 300);
        });
        resizeObserver.observe(canvas);

        let textEditorInput = win.textEditorInput;
        if (textEditorInput != undefined) {
          textEditorInput.addEventListener("input", NWT.onTextInput, true);
          textEditorInput.addEventListener("compositionstart", NWT.onTextInput, true);
          textEditorInput.addEventListener("compositionupdate", NWT.onTextInput, true);
          textEditorInput.addEventListener("compositionend", NWT.onTextInput, true);
          win.canvas.addEventListener("focus", (event) => {
            // no i18n
            if (textEditorInput.style.display != "none") {
              // no i18n
              textEditorInput.focus({ preventScroll: true });
            }
          });
        }

        //custom event listeners
        NWT.addNWTvent(canvas, "mousehold", NWT.onMouseHold, true); //No i18n
        NWT.addNWTvent(canvas, "longPress", NWT.onLongPress, true); //No i18n


        NWT.addNWTvent(window, "resize", NWT.onDisplayChanged, true); //No i18n
        NWT.addNWTvent(window, "blur", NWT.releaseEventProps, true); //No i18n

        // NWT.addNWTvent(window, "scroll", NWT.onMouseWheel, true); //No i18
      }
    }
  },

  htmlSetSingleClickStartCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "singleClickStartFunc", callback); //No i18n
  },

  htmlSetSingleClickEndCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "singleClickEndFunc", callback); //No i18n
  },

  htmlSetDoubleClickStartCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "doubleClickStartFunc", callback); //No i18n
  },

  htmlSetDoubleClickEndCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "doubleClickEndFunc", callback); //No i18n
  },

  htmlSetTripleClickStartCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "tripleClickStartFunc", callback); //No i18n
  },

  htmlSetTripleClickEndCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "tripleClickEndFunc", callback); //No i18n
  },

  htmlSetRightMouseUpCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "rightMouseUp", callback); //No i18n
  },

  htmlSetRightMouseDownCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "rightMouseDown", callback); //No i18n
  },

  htmlSetMouseHoldCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "mouseHoldFunc", callback); //No i18n
  },

  htmlSetLongPressCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "longPressFunc", callback); //No i18n
  },

  htmlSetCursorPosCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "cursorPosFunc", callback); //No i18n
  },

  htmlDragCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "dragFunc", callback); //No i18n
  },

  htmlSetScrollCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "scrollFunc", callback); //No i18n
  },

  htmlSetPinchZoomCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "pinchZoomFunc", callback); //No i18n
  },

  htmlSetScrollEndCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "scrollEndFunc", callback); //No i18n
  },

  htmlSetPinchZoomEndCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "zoomEndFunc", callback); //No i18n
  },

  htmlSetKeyDownCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "keyDownFunc", callback); //No i18n
  },

  htmlSetKeyUpCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "keyUpFunc", callback); //No i18n
  },

  htmlSetTextInputCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "textInputFunc", callback); //No i18n
  },

  htmlSetFramebufferResizeCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "framebufferResizeFunc", callback); //No i18n
  },
  htmlSetFramebufferResizeEndCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "framebufferResizeEndFunc", callback); //No i18n
  },

  htmlSetContentScaleCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "contentScaleFunc", callback); //No i18n
  },

  htmlSetMonitorResizeCallback: function (winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "monitorResizedFunc", callback); //No i18n
  },

  htmlSetEventQueueListener : function(winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "populateCustomEvents", callback); //No i18n
  },
  htmlClearEventQueueListener : function(winPtr, callback) {
    NWT.setCallbackOnWindow(winPtr, "clearCustomEvents", callback); //No i18n
  },
  
  htmlSetWindowUserPointer: function (winPtr, pointer) {
    let win = NWT.getWindowFromPtr(winPtr);
    if (win != undefined) {
      win.userptr = pointer;
    }
  },

  htmlGetWindowUserPointer: function (winPtr) {
    let win = NWT.getWindowFromPtr(winPtr);
    if (win != undefined) {
      return win.userptr;
    }
    return null;
  },

  htmlRemoveRegisteredEvents: function (winPtr) {
    let win = NWT.getWindowFromPtr(winPtr);
    if (win != undefined) {
      let canvas = win.canvas;
      NWT.registeredEvents.forEach((re) => {
        if (re.eventName != "webglcontextrestored") { // no i18n
          let target = re.target === canvas ? canvas : re.target;
          target.removeEventListener(re.eventName, re.callback, true);
        }
      });
    }
  },
  htmlOverrideMouseWheelBehaviour: function (needToOverride) {
    NWT.overrideMouseWheelDefault = needToOverride;
  }
};

autoAddDeps(LibraryNWT, "$NWT"); //No I18N
mergeInto(LibraryManager.library, LibraryNWT);
