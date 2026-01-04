#ifndef __GC_CORE_TYPES__
#define __GC_CORE_TYPES__

#include <vector>
#include <string>

#ifdef __APPLE__
#define GL_DPR(STR) [[deprecated(#STR)]]
#else
#define GL_DPR(STR)
#endif

using GCPostscriptFonts = std::vector<std::string>;

#endif

