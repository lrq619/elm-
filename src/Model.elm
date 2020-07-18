module Model exposing (..)
import Animation exposing (genAnimation)
import BasicFunctions exposing (backgroundSize, posToRealPos, unitSize)
import Basics exposing (..)
import GameObject exposing (GameObject, genGameObj, locate)
import Geometry exposing (genGeometry)
import Map exposing (Map, genMap, trap_1_location)
import NPC exposing (NPC, npcGroup)
import Sound exposing (..)
import State exposing (GameState(..))


type alias Model =
    {
     state : GameState,
     screen : (Float,Float),
     background : Image,
     hero : GameObject,
     passedTime : Float,
     moveLeft : Bool,
     moveRight : Bool,
     moveUp : Bool,
     moveDown : Bool,
     pause : Bool,
     start : Bool,
     interact : Bool,
     soundIndex: Int,
     sounds: List Sound,
     map : Map,
     traps : List GameObject,
     bufferOnTrap : Bool,
     npcs : List NPC,
     isTalking : Bool,
     talk : String

    }







genModel : Model
genModel =
    let
        screen=(0,0)
        (wD,hD)=(backgroundSize,backgroundSize)
        background=genImage "./static/Map005.png" 0 0 wD (hD)
        ----------------------------------------------------------------------------------------------
        srcLib_w_L = [
                    "./static/character/walking/5.png",
                    "./static/character/walking/6.png",
                    "./static/character/walking/7.png",
                    "./static/character/walking/8.png"
                    ]
        srcLib_w_R = [
                     "./static/character/walking/9.png",
                     "./static/character/walking/10.png",
                     "./static/character/walking/11.png",
                     "./static/character/walking/12.png"
                     ]
        srcLib_w_D = [
                    "./static/character/walking/1.png",
                    "./static/character/walking/2.png",
                    "./static/character/walking/3.png",
                    "./static/character/walking/4.png"
                    ]
        srcLib_w_U = [
                    "./static/character/walking/13.png",
                    "./static/character/walking/14.png",
                    "./static/character/walking/15.png",
                    "./static/character/walking/16.png"
                    ]
        normal = genAnimation ["./static/character/normal/1.png"] 10000
        walking_Left = genAnimation srcLib_w_L 200
        walking_Right = genAnimation srcLib_w_R 200
        walking_Up = genAnimation srcLib_w_U 200
        walking_Down = genAnimation srcLib_w_D 200
        animations = [normal,walking_Left,walking_Right,walking_Up,walking_Down]
        ------------------------------------------------------------------------------------------
        sound_n = genSound "" 10000000
        sound_1 = genSound "./static/sound/opengate.mp3" 2000
        pause = genSound "./static/sound/Attack1.m4a" 500
        interact = genSound "./static/sound/Blow2.m4a" 500
        onTrap = genSound "./static/sound/Reflection.m4a" 500
        sounds = [sound_n,sound_1,pause,interact,onTrap]
        ------------------------------------------------------------------------------------------
        startPoint = (1,1)
        (x,y) = posToRealPos startPoint
        geo = genGeometry x y unitSize unitSize (0,0)
        hero =
            locate (genGameObj geo animations) startPoint
        ------------------------------------------------------------------------------------------
        trapimg_1_pause = genAnimation [] 10000
        trapimg_1_active = genAnimation ["./static/traps/trap.png"] 10000
        trapimg_1 = [trapimg_1_pause,trapimg_1_active]
        trap_1 = genGameObj geo trapimg_1
        traps_1 = List.map (locate trap_1) trap_1_location

    in
    Model GamePlaying screen background
    hero 0
    False False False False False False False
    1 sounds
    genMap
    traps_1 False
    npcGroup False ""



type alias Image =
    { src : String
    , x : Float
    , y : Float
    , w : Float
    , h : Float
    , theta : Float
    }

genImage : String -> Float -> Float -> Float -> Float -> Image
genImage src x y w h =
    Image src x y w h 0




