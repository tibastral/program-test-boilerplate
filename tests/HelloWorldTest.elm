module HelloWorldTest exposing (tests)

import Backend
import Dict
import Effect.Lamdera exposing (sessionIdFromString)
import Effect.Subscription
import Effect.Test as TF exposing (HttpResponse(..))
import Frontend
import Json.Decode
import Test exposing (Test, describe)
import Time
import Types exposing (..)
import Url
import Effect.Browser.Dom as Dom exposing (HtmlId)


tests : List (TF.EndToEndTest ToBackend FrontendMsg FrontendModel ToFrontend BackendMsg BackendModel)
tests =
    [ helloWorldTest ]


helloWorldTest : TF.EndToEndTest ToBackend FrontendMsg FrontendModel ToFrontend BackendMsg BackendModel
helloWorldTest =
    TF.start "Test Hello World"
        (Time.millisToPosix 0)
        config
        [ TF.connectFrontend
            100
            (sessionIdFromString "session1")
            "/"
            { width = 900, height = 800 }
            (\client ->
                [ 
                    client.click 100 (Dom.id "hello-world")
                ]
            )
        ]


config : TF.Config ToBackend FrontendMsg FrontendModel ToFrontend BackendMsg BackendModel
config =
    TF.Config
        { init = Frontend.init
        , update = Frontend.update
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , updateFromBackend = Frontend.updateFromBackend
        , subscriptions = Frontend.subscriptions
        , view = Frontend.view
        }
        { init = Backend.init
        , update = Backend.update
        , updateFromFrontend = Backend.updateFromFrontend
        , subscriptions = Backend.subscriptions
        }
        handleHttpRequests
        handlePortToJs
        handleFileRequest
        handleFilesRequest
        (Url.fromString "http://localhost:8000" |> Maybe.withDefault (Url.Url Url.Http "localhost" (Just 8000) "/" Nothing Nothing))


handleHttpRequests : { a | currentRequest : TF.HttpRequest } -> HttpResponse
handleHttpRequests _ =
    StringHttpResponse
        { url = ""
        , statusCode = 200
        , statusText = "OK"
        , headers = Dict.empty
        }
        ""


handlePortToJs : { a | currentRequest : TF.PortToJs } -> Maybe ( String, Json.Decode.Value )
handlePortToJs _ =
    Nothing


handleFileRequest : { a | mimeTypes : List String } -> TF.FileUpload
handleFileRequest _ =
    TF.CancelFileUpload


handleFilesRequest : { a | mimeTypes : List String } -> TF.MultipleFilesUpload
handleFilesRequest _ =
    TF.CancelMultipleFilesUpload 