module GameObject exposing (..)
import Animation exposing (Animation)
import Geometry exposing (Geometry)

type alias GameObject =
    --{x : Float,
    -- y : Float,
    -- w : Float,
    -- h : Float,
    -- a : Float,
    {geometry : Geometry,
     actIndex : Int,
     actions : List Animation
    }

genGameObj : Geometry -> List Animation -> GameObject
genGameObj geo animations=
    GameObject geo 1 animations