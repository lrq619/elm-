module Update exposing (..)
import Sound exposing (..)
import BasicFunctions exposing (getValue, replace)
import GameObject exposing (GameObject, GameObjectState(..), act, addObjTime, calLength, changeNormal, returnObjZero, translate)
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
        MoveUp on ->
            ({ model | moveUp=on }
            ,Cmd.none)
        MoveDown on ->
            ({ model | moveDown=on }
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
        gameObj = model.gameObj

        objMsg =
            if gameObj.state /= ObjStopped then
                genGameObjMsg
                (genGeometryMsg (0,0) 0 GeoNone)
                (genAniMsg 0 AniNone False)
                ObjNone
            else if model.moveLeft  then
                genGameObjMsg
                (genGeometryMsg (-0.01,0) 800 GeoStart)
                (genAniMsg 2 AniStart False)
                ObjStart
            else if model.moveRight then
                genGameObjMsg
                (genGeometryMsg (0.01,0) 800 GeoStart)
                (genAniMsg 3 AniStart False)
                ObjStart
            else if model.moveUp then
                genGameObjMsg
                (genGeometryMsg (0,-0.01) 800 GeoStart)
                (genAniMsg 4 AniStart False)
                ObjStart
            else if model.moveDown then
                genGameObjMsg
                (genGeometryMsg (0,0.01) 800 GeoStart)
                (genAniMsg 5 AniStart False)
                ObjStart
            else
                genGameObjMsg
                (genGeometryMsg  (0,0) 0 GeoNone)
                (genAniMsg 0 AniNone False)
                ObjNone
        (normal,changeOrNot) =
            if model.moveLeft then
                (["./static/character/normal/2.png"],True)
            else if model.moveRight then
                (["./static/character/normal/3.png"],True)
            else if model.moveUp then
                (["./static/character/normal/4.png"],True)
            else if model.moveDown then
                (["./static/character/normal/1.png"],True)
            else
                ([],False)
        gameObj_ =
            changeNormal changeOrNot normal gameObj
        gameObj__ =
               gameObj_
                    |> receiveObjMsg objMsg
                    |> do elapsed objMsg
    in
        { model | gameObj = gameObj__ }

receiveObjMsg : GameObjMsg ->  GameObject -> GameObject
receiveObjMsg msg gameObj =
    let
        state =
            case msg.cmd of
                ObjStart ->
                    ObjPlaying
                ObjStop ->
                    ObjStopped
                ObjNone ->
                    gameObj.state
    in
        { gameObj | state = state }

do : Float -> GameObjMsg -> GameObject -> GameObject
do elapsed msg gameObj =
    let
        geoMsg = msg.geoMsg
        aniMsg = msg.aniMsg

    in
    case gameObj.state of
        ObjPlaying ->
            gameObj
                |> addObjTime elapsed
                |> returnObjZero
                |> changeAction aniMsg

                |> calLength
                |> translate geoMsg elapsed
                |> act aniMsg elapsed
        ObjStopped ->
            gameObj

changeAction : AnimationMsg -> GameObject -> GameObject
changeAction aniMsg gameObj =
    if aniMsg.cmd == AniNone then
        gameObj
    else
        { gameObj | actIndex = aniMsg.index }

soundDisplay:  Float -> Model -> Model
soundDisplay elapsed model =
     let
        soundMsg =
            if model.moveLeft then    -- this line will be changed after event index is added
               genSoundMsg 2 SoundStart True
            else
               genSoundMsg 0 SoundNone False

        model_=
                model
                |> changeSound soundMsg
                |> playSounds soundMsg elapsed
    in
        {model | soundIndex = model_.soundIndex,sounds = model_.sounds}
--wait to be solved


changeSound : SoundMsg -> Model -> Model
changeSound soundMsg  model =
    if soundMsg.cmd == SoundNone then
        model
    else
        { model | soundIndex = soundMsg.index }

playSounds : SoundMsg -> Float -> Model -> Model
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





