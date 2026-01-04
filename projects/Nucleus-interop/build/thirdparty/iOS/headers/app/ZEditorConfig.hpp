#ifndef __NL_ZEDITORCONFIG_H
#define __NL_ZEDITORCONFIG_H

class ZEditorConfig {
public:
    ZEditorConfig(){

    };
    virtual void onSelectShape() {
        // use this method to draw any kind of action icon once the shape selected
        // In VANI - we draw play button on top of selected iframe.
    }
};

#endif