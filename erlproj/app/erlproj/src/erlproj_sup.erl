%%%-------------------------------------------------------------------
%% @doc erlproj top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(erlproj_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
  io:format("Module ~p was started! ~n", [?MODULE]),
  SupFlags = #{strategy => one_for_all,
    intensity => 0,
    period => 1},
  ChildSpecs = [],


  dialer:start(),
  database:start(),

  {ok, {SupFlags, ChildSpecs}}.
