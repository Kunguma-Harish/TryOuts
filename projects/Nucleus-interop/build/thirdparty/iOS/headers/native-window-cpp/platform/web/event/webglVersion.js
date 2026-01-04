mergeInto(LibraryManager.library, {
    /**
     * Returns 0 if webgl is not found, or if there are any errors
     */
    get_webgl_version: function (canvasIdPtr, canvasIdSize) {
        let jsStringBytes = Module.HEAP8.slice(canvasIdPtr, canvasIdPtr + canvasIdSize);
        let jsString = new TextDecoder().decode(jsStringBytes);
        let canvas = document.querySelector(jsString);
        if (!canvas) {
            return 0;
        }
        var gl = canvas.getContext("webgl2"); // no i18n
        if (gl) {
            return 2;
        }
        gl = canvas.getContext("webgl"); // no i18n
        if (gl) {
            return 1;
        }
        return 0;
    },
    get_clipboard_string: function(ptr, func) {
        navigator.clipboard.readText().then(text => {
            wasmTable.get(func)(ptr, stringToUTF8OnStack(text));
        });
    },
    set_clipboard_string: function(cppString) {
        var str = maybeCStringToJsString(cppString);
        navigator.clipboard.writeText(str);
    }
});
