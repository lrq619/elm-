module Geometry exposing (..)
import Msg exposing (GeometryMsg, genGeometryMsg)
type alias Geometry =
    {x : Float,
     y : Float,
     w : Float,
     h : Float,
     a : Float,
     scale : Float,
     v : (Float,Float),
     av : Float
    }

genGeometry : Float -> Float -> Float -> Float -> Float -> Float-> (Float,Float)-> Float-> Geometry
genGeometry x y w h a scale v av=
    Geometry x y w h a scale v av

receiveGeoMsg : Maybe GeometryMsg -> Geometry -> Geometry
receiveGeoMsg msg geo =
    let
        msg_ =
            case msg of
                Just m ->
                    m
                Nothing ->
                    genGeometryMsg 0 (0,0) 0

        scale = msg_.scale
        v=msg_.velocity
        av=msg_.rotSpeed

    in
        case msg of
            Just m ->
                { geo | scale = scale,v=v,av=av }
            Nothing ->
                { geo | v=(0,0) }

doTranslation : Float -> Geometry -> Geometry
doTranslation elapsed geo =
    let
        (vx,vy)=geo.v
        (x_,y_)=(geo.x+vx*elapsed,geo.y+vy*elapsed)
        a_=geo.a + geo.av
        (w_,h_)=(geo.w*geo.scale,geo.h*geo.scale)
    in
        { geo | x=x_,y=y_,w=w_,h=h_,a=a_ }

