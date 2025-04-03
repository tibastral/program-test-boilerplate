module HelloWorldTest exposing (tests)

-- Essential imports for our end-to-end test
import Backend
import Dict
import Effect.Browser.Dom as Dom
import Effect.Lamdera exposing (sessionIdFromString)
-- 🛠️ Lamdera program-test framework
import Effect.Test as TF exposing (HttpResponse(..))
import Frontend
import Json.Decode
import Test.Html.Query
import Test.Html.Selector
import Time
import Types exposing (..)
import Url


-- 🎯 DESIGN: Collection of tests for this module
tests : List (TF.EndToEndTest ToBackend FrontendMsg FrontendModel ToFrontend BackendMsg BackendModel)
tests =
    [ helloWorldTest ]


-- 🛠️ DEVELOPMENT: Main test that validates the complete cycle
helloWorldTest : TF.EndToEndTest ToBackend FrontendMsg FrontendModel ToFrontend BackendMsg BackendModel
helloWorldTest =
    TF.start "Test Hello World"
        (Time.millisToPosix 0)
        config
        [ 
            -- 🚀 IMPLEMENTATION: First user - inputs data and verifies result
            TF.connectFrontend
                100
                (sessionIdFromString "session1")
                "/"
                { width = 900, height = 800 }
                (\client ->
                    [ 
                        -- Input framework name into the field
                        client.input 100 (Dom.id "best-framework") "react"
                        -- Action to save
                        , client.click 100 (Dom.id "save-the-world")
                        -- 📈 EVALUATION: Verify the view contains expected response
                        , client.checkView
                            100
                            (Test.Html.Query.has
                                [ 
                                    Test.Html.Selector.text "Thank you, Mario, but the slowness is in another framework"
                                    , Test.Html.Selector.text "Take that, react"
                                ]
                            )
                    ]
                )
                
            -- 🚀 IMPLEMENTATION: Second user - verifies data persistence
            , TF.connectFrontend
                5000
                (sessionIdFromString "session2")
                "/"
                { width = 900, height = 800 }
                (\client ->
                    [ 
                        -- 📈 EVALUATION: Check data is visible for another user
                        client.checkView
                            5000
                            (Test.Html.Query.has
                                [ Test.Html.Selector.text "Take that, react" ]
                            )
                            
                        -- 📈 EVALUATION: Check backend state directly
                        , TF.checkBackend
                            10000
                            (\backendModel ->
                                if backendModel.message == "react" then
                                    Ok ()
                                else
                                    Err "Message is not correct"
                            )
                            
                        -- 📈 EVALUATION: Verify complete application state
                        , TF.checkState
                            15000
                            (\state ->
                                if state.backend.message == "react" then
                                    Ok ()
                                else
                                    Err "Message is not correct"
                            )
                            
                        -- 📈 EVALUATION: Verify frontend model
                        , client.checkModel
                            20000
                            (\frontendModel ->
                                if frontendModel.message == "Thank you, Mario, but the slowness is in another framework. Take that, react" then
                                    Ok ()
                                else
                                    Err "Message is not correct"
                            )
                    ]
                )
        ]


-- 🎯 DESIGN: Test configuration
config : TF.Config ToBackend FrontendMsg FrontendModel ToFrontend BackendMsg BackendModel
config =
    TF.Config
        -- Frontend configuration
        { init = Frontend.init
        , update = Frontend.update
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , updateFromBackend = Frontend.updateFromBackend
        , subscriptions = Frontend.subscriptions
        , view = Frontend.view
        }
        -- Backend configuration
        { init = Backend.init
        , update = Backend.update
        , updateFromFrontend = Backend.updateFromFrontend
        , subscriptions = Backend.subscriptions
        }
        -- 🛠️ Mock handlers
        handleHttpRequests
        handlePortToJs
        handleFileRequest
        handleFilesRequest
        (Url.fromString "http://localhost:8000" |> Maybe.withDefault (Url.Url Url.Http "localhost" (Just 8000) "/" Nothing Nothing))


-- 🛠️ DEVELOPMENT: Mock for HTTP requests
handleHttpRequests : { a | currentRequest : TF.HttpRequest } -> HttpResponse
handleHttpRequests _ =
    StringHttpResponse
        { url = ""
        , statusCode = 200
        , statusText = "OK"
        , headers = Dict.empty
        }
        ""


-- Mock for JavaScript ports
handlePortToJs : { a | currentRequest : TF.PortToJs } -> Maybe ( String, Json.Decode.Value )
handlePortToJs _ =
    Nothing


-- Mock for file uploads
handleFileRequest : { a | mimeTypes : List String } -> TF.FileUpload
handleFileRequest _ =
    TF.CancelFileUpload


-- Mock for multiple uploads
handleFilesRequest : { a | mimeTypes : List String } -> TF.MultipleFilesUpload
handleFilesRequest _ =
    TF.CancelMultipleFilesUpload