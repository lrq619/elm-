module View exposing (..)
import Animation exposing (genAnimation)
import Sound exposing (genSound)
import GameObject exposing (GameObject)
import Model exposing (..)
import BasicFunctions exposing (..)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (autoplay, controls, loop, src)
import Svg exposing (..)
import Svg.Attributes as SvgAttr
import Html.Attributes


view : Model -> Html.Html msg
view model =
    let

        (w,h)=model.screen
        w_=String.fromFloat w
        h_=String.fromFloat h
    in
    div
        [
          HtmlAttr.style "width" (w_ ++ "px")
        , HtmlAttr.style "height" (h_ ++ "px")
        , HtmlAttr.style "position" "absolute"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "0"
        ]
        [
            render model,
            renderSound model,
            renderInfo model
        ]



render : Model -> Html.Html msg
render model=
  let
    (wS,hS)= model.screen
    (wD,hD)= display

    x = String.fromFloat ((wS - wD)/2)
    y = String.fromFloat ((hS - hD)/2)
    w = String.fromFloat wD
    h = String.fromFloat hD
    background=model.background

    viewH = 200
    viewW = 200

    viewX = model.hero.geometry.x - viewW / 2
    viewY = model.hero.geometry.y - viewH / 2

  in
  Svg.svg
    [ --SvgAttr.viewBox ("350" ++ " " ++ "250" ++ " " ++ "100" ++ " " ++ "100"),
      SvgAttr.viewBox (String.fromFloat viewX ++ " " ++ String.fromFloat viewY ++ " " ++
       String.fromFloat viewW ++ " " ++ String.fromFloat viewH),
      Html.Attributes.style "position" "fixed",
      HtmlAttr.style "left" (x ++ "px"),
      HtmlAttr.style "top" (y ++ "px"),
      SvgAttr.width (w ++ "px"),
      SvgAttr.height (h ++ "px")
    ]
     (

     renderImage background
     --::renderImage picture
     ::renderGameObj model.hero
     ::[]
     )

renderGameObj : GameObject -> Svg.Svg msg
renderGameObj gameobj =
    let
        geo=gameobj.geometry
        x=geo.x
        y=geo.y
        w=geo.w
        h=geo.h

        aniIndex = gameobj.actIndex

        ani = case getValue gameobj.actions aniIndex of
                Just animation ->
                    animation
                Nothing ->
                    genAnimation [] 1

        src=case getValue ani.srcLib ani.stage of
                Just string ->
                    string
                Nothing ->
                    ""

        img = genImage src x y w h
    in
        renderImage img


renderImage : Image -> Svg.Svg msg
renderImage picture=
    let
        src=picture.src

        w=String.fromFloat picture.w
        h=String.fromFloat picture.h

    in
    Svg.image
        (  SvgAttr.xlinkHref src
        :: SvgAttr.width (w)
        :: SvgAttr.height (h)
        :: SvgAttr.transform (renderTransform picture)
        :: SvgAttr.preserveAspectRatio "none"
        :: HtmlAttr.style "position" "fixed"
        :: []
        )
        []

renderTransform : Image ->String
renderTransform picture =
    let
        x=String.fromFloat picture.x
        y=String.fromFloat picture.y

        theta=String.fromFloat picture.theta
    in

    "translate(" ++  x ++ "," ++ y ++ ") rotate(" ++  theta ++ ")"
    --++ " translate(" ++ String.fromFloat (-picture.w/2)  ++ "," ++ String.fromFloat (-picture.h/2) ++ ")"

renderInfo : Model -> Html msg
renderInfo model =
    let
        (x,y) = model.hero.pos
        info=
            --String.fromFloat model.gameObj.geometry.x ++","++ String.fromFloat model.gameObj.geometry.y ++ "\n" ++
            String.fromInt x ++ "," ++ String.fromInt y

    in
    div
        [ HtmlAttr.style "background" "rgba(0, 0, 0, 0.85)"
        , HtmlAttr.style "color" "#e2e4e7"
        , HtmlAttr.style "font-family" "Helvetica, Arial, sans-serif"
        , HtmlAttr.style "font-size" "18px"
        , HtmlAttr.style "width" "300px"
        , HtmlAttr.style "height" "270px"
        , HtmlAttr.style "left" "0"
        , HtmlAttr.style "top" "500px"
        , HtmlAttr.style "line-height" "1.5"
        , HtmlAttr.style "padding" "0 15px"
        , HtmlAttr.style "position" "absolute"
        ]
        [
        Html.text info
        ]

renderSound : Model -> Html msg
renderSound model =
    let
        sound = case ( getValue model.sounds model.soundIndex) of
            Just a ->
                a
            Nothing ->
                genSound "" 0
        src = sound.srcLib
    in
      audio [
      HtmlAttr.src src,
      HtmlAttr.autoplay True
      ] [Html.text "You browser does not support audio"]