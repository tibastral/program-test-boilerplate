module Frontend exposing (..)

import Effect.Browser exposing (UrlRequest)
import Effect.Browser.Navigation as Nav
import Effect.Command as Command exposing (Command)
import Effect.Lamdera
import Effect.Subscription as Subscription exposing (Subscription)
import Html
import Html.Attributes as Attr
import Types exposing (..)
import Url
import Html.Events as Events
import Lamdera


type alias Model =
    FrontendModel



-- app : Effect.Lamdera.Program () Model FrontendMsg
app =
    Effect.Lamdera.frontend
        Lamdera.sendToBackend
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlClicked
        , subscriptions = subscriptions
        , update = update
        , updateFromBackend = updateFromBackend
        , view = view
        }


subscriptions : Model -> Subscription Command.FrontendOnly FrontendMsg
subscriptions arg1 =
    Subscription.none

    -- Effect.Lamdera.frontend
    --     { init = init
    --     , onUrlRequest = UrlClicked
    --     , onUrlChange = UrlChanged
    --     , update = update
    --     , updateFromBackend = updateFromBackend
    --     , subscriptions = \m -> Subscription.none
    --     , view = view
    --     }


-- init : Url.Url -> Nav.Key -> ( Model, Command restriction toMsg FrontendMsg )
init url key =
    ( { key = key
      , message = "Welcome to Lamdera! You're looking at the auto-generated base implementation. Check out src/Frontend.elm to start coding!"
      }
    , Effect.Lamdera.sendToBackend GetMessage
    )


-- update : FrontendMsg -> Model -> ( Model, Command restriction toMsg FrontendMsg )
update msg model =
    case msg of
        ChangeMessage newMessage ->
            ( { model | message = newMessage }, Command.none )

        SaveTheWorld ->
            ( model, Effect.Lamdera.sendToBackend (BackendSaveTheWorld model.message) )

        _ ->
            ( model, Command.none )
    -- case msg of
    --     UrlClicked urlRequest ->
    --         ( model, Command.none)
    --         -- case urlRequest of
    --         --     Effect.Browser.Internal url ->
    --         --         ( model
    --         --         , Effect.Browser.Navigation.pushUrl model.key (Url.toString url)
    --         --         )

    --         --     Effect.Browser.External url ->
    --         --         ( model
    --         --         , Effect.Browser.Navigation.load url
    --         --         )

    --     UrlChanged url ->
    --         ( model, Command.none )

    --     NoOpFrontendMsg ->
    --         ( model, Command.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Command restriction toMsg FrontendMsg )
updateFromBackend msg model =
    case msg of
        ChangeMessageInFrontend newMessage ->
            ( { model | message = newMessage }, Command.none )


view : Model -> Effect.Browser.Document FrontendMsg
view model =
    { title = ""
    , body =
        [ Html.div [ Attr.style "text-align" "center", Attr.style "padding-top" "40px" ]
            [ Html.img [ Attr.src "https://lamdera.app/lamdera-logo-black.png", Attr.width 150 ] []
            , Html.div
                [ Attr.style "font-family" "sans-serif"
                , Attr.style "padding-top" "40px"
                ]
                [ Html.text model.message ]
            , Html.input [ Attr.id "best-framework", Events.onInput ChangeMessage ] []
            , Html.button [ Events.onClick SaveTheWorld, Attr.id "save-the-world" ] [ Html.text "Click me" ]
            ]
        ]
    }
