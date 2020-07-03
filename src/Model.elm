module Model exposing (..)
import Animation exposing (genAnimation)
import Basics exposing (..)
import GameObject exposing (GameObject, genGameObj)
import Geometry exposing (genGeometry)

type alias Model =
    {picture : Image,
     screen : (Float,Float),
     background : Image,
     gameObj : GameObject,
     passedTime : Float,
     moveLeft : Bool,
     moveRight : Bool
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
        srcLib_w = [
                    "./static/walking/1.png",
                    "./static/walking/2.png",
                    "./static/walking/3.png",
                    "./static/walking/4.png"
                    ]
        srcLib = [
                  "./static/light/252.png",
                  "./static/light/253.png",
                  "./static/light/254.png",
                  "./static/light/255.png",
                  "./static/light/256.png",
                  "./static/light/257.png",
                  "./static/light/258.png",
                  "./static/light/259.png"
                  ]
        srcLib_r = List.reverse srcLib
        srcLib_dis = [
                      "./static/disappear/1.png",
                      "./static/disappear/2.png",
                      "./static/disappear/3.png",
                      "./static/disappear/4.png",
                      "./static/disappear/5.png",
                      "./static/disappear/6.png",
                      "./static/disappear/7.png"
                        ]
        walking = genAnimation srcLib_w 200
        magic = genAnimation srcLib 50
        reverse = genAnimation srcLib_r 200
        disappear = genAnimation srcLib_dis 100
        animations = [walking,magic,reverse,disappear]
        geo = genGeometry 400 300 10 10 0 1 (0,0) 0
        gameObj =
            genGameObj geo animations
    in
    Model picture screen background gameObj 0 False False



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
