module Backend exposing (..)

import Effect.Command as Command exposing (Command)
import Effect.Lamdera exposing (ClientId, SessionId)
import Lamdera
import Effect.Subscription as Subscription exposing (Subscription)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Effect.Lamdera.backend
        Lamdera.broadcast
        Lamdera.sendToFrontend
        { init = init
        , subscriptions = subscriptions
        , update = update
        , updateFromFrontend = updateFromFrontend
        }


subscriptions : Model -> Subscription Command.BackendOnly BackendMsg
subscriptions arg1 =
    Subscription.none


init : ( Model, Command restriction toMsg BackendMsg )
init =
    ( { message = "Hello!" }
    , Command.none
    )


update : BackendMsg -> Model -> ( Model, Command restriction toMsg BackendMsg )
update msg model =
    case msg of
        NoOpBackendMsg ->
            ( model, Command.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Command restriction toMsg BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( model, Command.none )
