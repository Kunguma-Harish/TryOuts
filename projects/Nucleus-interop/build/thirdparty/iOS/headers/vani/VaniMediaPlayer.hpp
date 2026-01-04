#ifndef __NL_VANIMEDIAPLAYER_H
#define __NL_VANIMEDIAPLAYER_H

#include <app/controllers/NLEventController.hpp>
#include <app/controllers/NLEditorProperties.hpp>
#include <nucleus/core/layers/NLInstanceLayer.hpp>
#include <skia-extension/GLRect.hpp>

#define SEEKER_LEFT 403
#define TOTAL_SEEKER_WIDTH 272
class VaniMediaPlayer {
    struct currentAudioPlayer {
        float currentTime;
        float audioDuration;
        std::string shapeId;
        bool currentPlaying;
        bool playerInitialized;
        bool dragStarted;
        graphikos::painter::GLRect OnDragseekerRect;
        bool renameMode;
        std::string renameShapeId;
        currentAudioPlayer() {
            this->currentTime = 0; //in sec
            this->audioDuration = 0;
            this->shapeId = "";
            this->currentPlaying = false;
            this->playerInitialized = false;
            this->dragStarted = false;
            this->OnDragseekerRect = graphikos::painter::GLRect();
            this->renameMode = false;
            this->renameShapeId = "";
        }
    };
    static currentAudioPlayer playerDetials;

public:
    static currentAudioPlayer getPlayerDetials();
    static void audioPlayerDrag(const graphikos::painter::GLPoint& end);
    static bool isAudioPlayerInitialized(std::string shapeId);
    static float getProgressSeekerWidth();
    static void toggleAudioPlayMode();
    static void currentTime(float time);
    static void reset();
    static void reset(std::string shapeId);
    static void renameMode(bool mode, std::string renameShapeId);
    static void playingState(bool state);
    static void initializeAudioPlayer(std::string shapeId, float audioDuration);
    static void setDragStarted(graphikos::painter::GLRect seekerRect, bool dragStarted);
    static bool isCurrentPlaying();
    static bool isRenameMode(std::string shapeId);
};

#endif