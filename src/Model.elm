module Model exposing (..)
import Animation exposing (genAnimation)
import Basics exposing (..)
import GameObject exposing (GameObject, genGameObj)
import Geometry exposing (genGeometry)
import Sound exposing (..)


type alias Model =
    {
     screen : (Float,Float),
     background : Image,
     gameObj : GameObject,
     passedTime : Float,
     moveLeft : Bool,
     moveRight : Bool,
     moveUp : Bool,
     moveDown : Bool,
     soundIndex: Int,
     sounds: List Sound
    }



tests : List String
tests =
    ["First","Second","Third"]


display : (Float,Float)
display =
    (800,600)

genModel : Model
genModel =
    let
        screen=(0,0)
        (wD,hD)=(2400,2400)

        background=genImage "./static/Map004.png" (wD/2) (hD/2) wD (hD)
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
        sound_n = genSound "" 10000000
        sound_1 = genSound "./static/Sound/opengate.mp3" 2000
        sound_2 = genSound "./static/Sound/heartbeat-fast.mp3" 3000
        sounds = [sound_n,sound_1, sound_2]
        geo = genGeometry 0 0 10 10 (0,0)
        gameObj =
            genGameObj geo animations
    in
    Model screen background gameObj 0
    False False False False
    1 sounds



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
