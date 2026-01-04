#ifndef __NL_ISWAPBUFFERLISTENER_H
#define __NL_ISWAPBUFFERLISTENER_H

struct OnSwapBufferListener {
	virtual void onSwapBuffer() = 0;
};

#endif
