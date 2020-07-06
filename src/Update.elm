module Update exposing (..)
import Animation exposing (doAnimation, genAnimation, receiveAniMsg)
import Sound exposing (..)
import BasicFunctions exposing (getValue, replace)
import GameObject exposing (GameObject)
import Geometry exposing (doTranslation, receiveGeoMsg)
import Model exposing (..)
import Msg exposing (..)
import Platform.Cmd exposing (..)
import Basics exposing (..)
import State exposing (AnimationState(..), SoundState(..))

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
                |> soundDisplay (min elapsed 25)
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
            if model.moveLeft then
               Just (genAniMsg 2 AniStart False)
            else if model.moveRight then
               Just(genAniMsg 3 AniStart False)
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
        index_ =
            if ani_.state == AniStopped then
                1
            else
                gameObj.actIndex
    in
        { gameObj | actions = actions_,actIndex=index_ }





soundDisplay:  Float -> Model -> Model
soundDisplay elapsed model =
     let
        soundMsg =
            if model.moveLeft then    -- this line will be changed after event index is added
               Just (genSoundMsg 2 SoundStart True)
            else
                Nothing

        model_=
                model
                |> changeSound soundMsg
                |> playSounds soundMsg elapsed
    in
        {model | soundIndex = model_.soundIndex,sounds = model_.sounds}
--wait to be solved


changeSound : Maybe SoundMsg -> Model -> Model
changeSound soundMsg  model =
    case soundMsg of
        Just msg ->
            { model | soundIndex = msg.index }
        Nothing ->
            model

playSounds : Maybe SoundMsg -> Float -> Model -> Model
playSounds soundMsg elapsed model =
    let
        sound = case (getValue model.sounds model.soundIndex) of
               Just a ->
                  a
               Nothing ->
                   genSound "" 0

        sound_ =
            sound
                |> receiveSoundMsg soundMsg
                |> doSound elapsed

        sounds_ = replace model.sounds model.soundIndex sound_
        index_ =
            if sound_.state == SoundStopped then
                1
            else
                model.soundIndex
    in
         {model | sounds = sounds_,soundIndex = index_}





