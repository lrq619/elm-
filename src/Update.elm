module Update exposing (..)
import NPC exposing (NPC, checkSame, genNPC)
import Sound exposing (..)
import BasicFunctions exposing (getValue, replace,getValueIndex)
import GameObject exposing (GameObject, GameObjectState(..), act, addObjTime, calLength, changeNormal, checkBarrier, getNormal, returnObjZero, translate)
import Model exposing (..)
import Msg exposing (..)
import Platform.Cmd exposing (..)
import Basics exposing (..)
import State exposing (AnimationState(..), GameState(..), SoundState(..))
import Map exposing (trap_1_location)

update : SysMsg -> Model -> (Model,Cmd msg)
update msg model =
        case msg of
            Pause on->
                ({model | state=GamePause,pause=on},Cmd.none)
            Start on ->
                ({model | state = GamePlaying,start=on,isTalking = False},Cmd.none)

            GetViewport viewport ->
                ({ model | screen = (viewport.viewport.width,viewport.viewport.height)},Cmd.none)

            Resize width height->
                ( { model | screen = (toFloat width, toFloat height) },Cmd.none)

            Interact on ->
                ( { model | interact=on },Cmd.none )

            MoveRight on ->
                ({ model | moveRight=on,isTalking = False }
                ,Cmd.none)

            MoveLeft on->
                ({ model | moveLeft=on,isTalking = False }
                ,Cmd.none)
            MoveUp on ->
                ({ model | moveUp=on,isTalking = False }
                ,Cmd.none)
            MoveDown on ->
                ({ model | moveDown=on,isTalking = False }
                ,Cmd.none)
            Tick elapsed->
                if model.state == GamePlaying then
                    (model
                        |> recordBuffer
                        |> heroStateCheck (min elapsed 25) model.hero

                        |> addTotalTime (min elapsed 25)
                        |> gameDisplay (min elapsed 25)
                        |> soundDisplay (min elapsed 25)
                        |> interact
                            ,Cmd.none)
                else
                    (model
                        |> checkStart
                        |> soundDisplay (min elapsed 25)

                    ,Cmd.none)

            Noop ->
                ({model | isTalking = False},Cmd.none)

            --_ ->
            --    (model,Cmd.none)

recordBuffer : Model -> Model
recordBuffer model=
    let
        onTrap = model.hero.onTrap
    in
        { model | bufferOnTrap = onTrap }
checkStart : Model -> Model
checkStart model =
    if model.start then
        { model | state=GamePlaying }
    else
        model

interact : Model -> Model
interact model=
    let
        talk = getTalk model.hero model.npcs
    in
    if model.interact == False then
        model
    else
        if talk /= "" then
            { model | talk = talk,isTalking=True }
        else
            model

getTalk : GameObject -> List NPC -> String
getTalk hero npcs =
    let
        (x,y)=hero.pos
        (x_,y_) =
            if getNormal hero == "./static/character/normal/1.png" then
                    (0,1)
            else if getNormal hero == "./static/character/normal/2.png" then
                    (-1,0)
            else if getNormal hero == "./static/character/normal/3.png" then
                    (1,0)
            else if getNormal hero == "./static/character/normal/4.png" then
                    (0,-1)
            else
                (0,0)
        pos_ = (x+x_,y+y_)
        npcSingleList=List.filter (checkSame pos_) npcs
        talk = case getValue npcSingleList 1 of
                Just n ->
                    n.talk
                Nothing ->
                    ""
    in
        talk

addTotalTime : Float -> Model -> Model
addTotalTime elapsed model =
    { model | passedTime = model.passedTime + elapsed }

gameDisplay : Float -> Model -> Model
gameDisplay elapsed model =
    let
        hero = model.hero
        map = model.map
        objMsg =
            if hero.state /= ObjStopped then
                genGameObjMsg
                (genGeometryMsg (0,0) 0 GeoNone)
                (genAniMsg 0 AniNone False)
                ObjNone
            else if model.moveLeft && not (checkBarrier map hero (-1,0)) then
                genGameObjMsg
                (genGeometryMsg (-0.03,0) 800 GeoStart)
                (genAniMsg 2 AniStart False)
                ObjStart
            else if model.moveRight && not (checkBarrier map hero (1,0)) then
                genGameObjMsg
                (genGeometryMsg (0.03,0) 800 GeoStart)
                (genAniMsg 3 AniStart False)
                ObjStart
            else if model.moveUp && not (checkBarrier map hero (0,-1))then
                genGameObjMsg
                (genGeometryMsg (0,-0.03) 800 GeoStart)
                (genAniMsg 4 AniStart False)
                ObjStart
            else if model.moveDown&& not (checkBarrier map hero (0,1)) then
                genGameObjMsg
                (genGeometryMsg (0,0.03) 800 GeoStart)
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
        hero_ =
            changeNormal changeOrNot normal hero
        hero__ =
               hero_
                    |> receiveObjMsg objMsg
                    |> do elapsed objMsg
    in
        { model | hero = hero__ }

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
            ---Sound effect when game is paused---
            if model.state == GamePause then
                if model.pause || model.start then
                    genSoundMsg 3 SoundStart True
                else
                   genSoundMsg 0 SoundNone False
           ---Sound effect when game is playing---
            else
                if model.pause || model.start then
                    genSoundMsg 3 SoundStart True
                else if model.interact && model.isTalking then
                    genSoundMsg 4 SoundStart True
                else if model.hero.onTrap == True && model.bufferOnTrap == False then
                    genSoundMsg 5 SoundStart True
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


heroStateCheck : Float -> GameObject -> Model-> Model
heroStateCheck elapsed hero model=
    let hero_position = hero.pos
        trap1_index = getValueIndex hero_position trap_1_location
         --------------Poisonous PlACE-----------------------
        (hero_postion_x, hero_postion_y)=hero_position
        hero_blood_=
            if hero_postion_x >= 16 then
                hero.hero_blood - 0.0005 * elapsed
            else
                hero.hero_blood
        --------------Trap-----------------------
        traps = model.traps
        substitute_trap =
                case (getValue model.traps trap1_index) of
                        Just a ->
                            a
                        Nothing ->
                            model.hero -----arbitrary choice

        substitute_trap_ = {substitute_trap | actIndex = 2}
        new_traps =
            if trap1_index == 0 then
                traps
            else
                replace traps trap1_index substitute_trap_
        hero_ = if trap1_index == 0 then
                    { hero | hero_blood = hero_blood_, onTrap = False }
                else
                    if hero.onTrap == False then
                        { hero | hero_blood = hero_blood_ - 20, onTrap = True }
                    else
                        hero
    in
            if trap1_index == 0 then
                { model | hero = hero_ }
            else
                if hero.onTrap == False then
                    { model | hero=hero_, traps = new_traps}
                else
                    { model | hero=hero_,traps = new_traps }





