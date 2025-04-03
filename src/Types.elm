module Types exposing (..)

import Effect.Browser exposing (UrlRequest)
import Effect.Browser.Navigation exposing (Key)
import Url exposing (Url)


type alias FrontendModel =
    { key : Effect.Browser.Navigation.Key
    , message : String
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Effect.Browser.UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | ChangeMessage String
    | SaveTheWorld
type ToBackend
    = BackendSaveTheWorld String
    | GetMessage

type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = ChangeMessageInFrontend String
