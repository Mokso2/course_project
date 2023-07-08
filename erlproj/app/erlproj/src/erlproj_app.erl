%%%-------------------------------------------------------------------
%% @doc erlproj public API
%% @end
%%%-------------------------------------------------------------------

-module(erlproj_app).

-behaviour(application).

-include_lib("C:\Users\79513\nksip\include\nksip.hrl").

-export([start/2, stop/1]).


start(_StartType, _StartArgs) ->

    Dispatch = cowboy_router:compile([
        {'_', [
            {"/abonent", db_abonent_http_handler, []},
            {"/abonents", db_abonents_http_handler, []},
            {"/call", callabonent_http_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
        env => #{dispatch => Dispatch}}
    ),

    erlproj_sup:start_link().

stop(_State) ->
    ok.


%% internal functions
