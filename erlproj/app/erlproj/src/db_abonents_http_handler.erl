
-module(db_abonents_http_handler).
-author("Maksim").

-export([init/2, abonents/2]).

-include("abonents.hrl").

init(Req0, State)->
  Method = cowboy_req:method(Req0),
  Req = abonents(Method, Req0),
  {ok, Req, State}.

abonents(<<"GET">>, Req0)->
  {atomic, Data} = database:get_abonents(),
  Numbers = [Number || {abonents, Number, _} <- Data],
  Names = [list_to_binary(Name) || {abonents, _, Name} <- Data],
  req_reply:reply_abonents_data(Names, Numbers, Req0);

abonents(_, Req0)->
  req_reply:reply_404(Req0).