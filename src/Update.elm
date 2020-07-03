module Update exposing (..)
import Animation exposing (doAnimation, genAnimation, receiveAniMsg)
import BasicFunctions exposing (getValue, replace)
import GameObject exposing (GameObject)
import Geometry exposing (doTranslation, receiveGeoMsg)
import Model exposing (..)
import Msg exposing (..)
import Platform.Cmd exposing (..)
import Basics exposing (..)

update : SysMsg -> Model -> (Model,Cmd msg)
update msg model =
    case msg of
        GetViewport viewport ->
            ({ model | screen = (viewport.viewport.width,viewport.viewport.height)},Cmd.none)

        Resize width height->
            ( { model | screen = (toFloat width, toFloat height) },Cmd.none)

        MoveRight on->
            ({ model | moveRight=on }
            ,Cmd.none)

        MoveLeft on->
            ({ model | moveLeft=on }
            ,Cmd.none)

        Tick elapsed->
            (model
                |> addTotalTime (min elapsed 25)
                |> gameDisplay (min elapsed 25)
            ,Cmd.none)

        Noop ->
            (model,Cmd.none)

addTotalTime : Float -> Model -> Model
addTotalTime elapsed model =
    { model | passedTime = model.passedTime + elapsed }

gameDisplay : Float -> Model -> Model
gameDisplay elapsed model =
    let
        gameobj = model.gameObj
        geoMsg =
            if model.moveLeft then
                Just (genGeometryMsg 1 (-0.01,0) 0)
            else
                Nothing

        aniMsg =
            if model.passedTime >=100 && model.passedTime <= 200 then
               Just (genAniMsg 1 AniStart True)
            else
                Nothing

        gameobj_ =
            gameobj
                |> translate geoMsg elapsed
                |> changeAction aniMsg
                |> act aniMsg elapsed
    in
        { model | gameObj = gameobj_ }

translate : Maybe GeometryMsg -> Float -> GameObject -> GameObject
translate geoMsg elapsed gameObj =
    let
        geo = gameObj.geometry
        geo_ =
            geo
                |> receiveGeoMsg geoMsg
                |> doTranslation elapsed
    in
        { gameObj | geometry = geo_ }

changeAction : Maybe AnimationMsg -> GameObject -> GameObject
changeAction aniMsg gameObj =
    case aniMsg of
        Just msg ->
            { gameObj | actIndex = msg.index }
        Nothing ->
            gameObj

act : Maybe AnimationMsg -> Float -> GameObject -> GameObject
act aniMsg elapsed gameObj =
    let
        ani = case (getValue gameObj.actions gameObj.actIndex) of
                Just a ->
                    a
                Nothing ->
                    genAnimation [] 1
        ani_ =
            ani
                |> receiveAniMsg aniMsg
                |> doAnimation elapsed
        actions_ = replace gameObj.actions gameObj.actIndex ani_

    in
        { gameObj | actions = actions_ }

