module Views exposing (view)

import Http exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import Html.Attributes exposing (placeholder, class, src, type')
import Models exposing (Model, DominoAppMessage(..), Actor, Status(..))


view : Model -> Html DominoAppMessage
view model =
    div []
        ([ renderHeader ]
            ++ [ renderSearchField model ]
            ++ [ renderMain model ]
            ++ [ renderDebugButtons ]
        )


renderMain : Model -> Html DominoAppMessage
renderMain model =
    case model.status of
        Initial ->
            div [] [ text "Type name then click Search" ]

        InProgress ->
            div [] [ text "Search pending…" ]

        Loaded ->
            renderActorsListView model.actors

        Error ->
            div [] (renderErrorMessage model.errorMessage)


renderErrorMessage : Maybe String -> List (Html DominoAppMessage)
renderErrorMessage maybeErrors =
    case maybeErrors of
        Nothing ->
            []

        Just errors ->
            [ div [ class "bg-danger" ] [ text errors ] ]


renderSearchField : Model -> Html DominoAppMessage
renderSearchField model =
    form [ onSubmit SearchClicked ]
        [ div [ class "input-group" ]
            [ input
                [ placeholder "e.g. Uma Thurman"
                , onInput TextChanged
                , class "form-control"
                ]
                [ text model.actorSearchFieldText ]
            , span
                [ class "input-group-btn"
                ]
                [ button
                    [ type' "submit"
                    , class "btn btn-default"
                    ]
                    [ text "Search" ]
                ]
            ]
        ]


renderHeader : Html DominoAppMessage
renderHeader =
    h1 [] [ text "Movie Domino" ]


renderActorsListView : Maybe (List Actor) -> Html DominoAppMessage
renderActorsListView maybeActors =
    case maybeActors of
        Nothing ->
            text "No results"

        Just actors ->
            div [ class "list-group" ] (List.map renderActorView actors)


renderActorView : Actor -> Html DominoAppMessage
renderActorView actor =
    button [ class "list-group-item" ]
        [ case actor.image of
            Just url ->
                img [ src ("http://image.tmdb.org/t/p/w45" ++ url) ]
                    []

            _ ->
                text ""
        , text actor.name
        ]


renderDebugButtons : Html DominoAppMessage
renderDebugButtons =
    div []
        [ span [] [ text "Error testing: " ]
        , div [ class "btn-group" ]
            [ button
                [ onClick (SearchFailed Timeout)
                , class "btn btn-danger"
                ]
                [ text "Timeout" ]
            , button
                [ onClick (SearchFailed NetworkError)
                , class "btn btn-danger"
                ]
                [ text "Network Error" ]
            , button
                [ onClick (SearchFailed (UnexpectedPayload "Text of the error"))
                , class "btn btn-danger"
                ]
                [ text "Unexpected Payload" ]
            , button
                [ onClick (SearchFailed (BadResponse 404 "Not found"))
                , class "btn btn-danger"
                ]
                [ text "Bad Response" ]
            ]
        ]
