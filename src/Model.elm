module Model exposing (..)
import Animation exposing (genAnimation)
import Basics exposing (..)
import GameObject exposing (GameObject, genGameObj)
import Geometry exposing (genGeometry)
import Sound exposing (..)


type alias Model =
    {picture : Image,
     screen : (Float,Float),
     background : Image,
     gameObj : GameObject,
     passedTime : Float,
     moveLeft : Bool,
     moveRight : Bool,
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
        (wD,hD)=display
        picture=genImage "" 400 300 50 50 180
        background=genImage "./static/boss_normal.png" (wD/2) (hD/2) wD (hD) 0
        srcLib_w_L = [
                    "./static/walking/5.png",
                    "./static/walking/6.png",
                    "./static/walking/7.png",
                    "./static/walking/8.png"
                    ]
        srcLib_w_R = [
                     "./static/walking/9.png",
                     "./static/walking/10.png",
                     "./static/walking/11.png",
                     "./static/walking/12.png"
                     ]
        normal = genAnimation ["./static/walking/1.png"] 10000
        walking_Left = genAnimation srcLib_w_L 200
        walking_Right = genAnimation srcLib_w_R 200
        animations = [normal,walking_Left,walking_Right]
        sound_n = genSound "" 10000000
        sound_1 = genSound "./static/Sound/opengate.mp3" 2000
        sound_2 = genSound "./static/Sound/heartbeat-fast.mp3" 3000
        sounds = [sound_n,sound_1, sound_2]
        geo = genGeometry 400 300 10 10 0 1 (0,0) 0
        gameObj =
            genGameObj geo animations
    in
    Model picture screen background gameObj 0 False False 1 sounds



type alias Image =
    { src : String
    , x : Float
    , y : Float
    , w : Float
    , h : Float
    , theta : Float
    }

genImage : String -> Float -> Float -> Float -> Float -> Float -> Image
genImage src x y w h theta=
    Image src x y w h theta
