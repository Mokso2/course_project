
-module(db_abonent_http_handler).
-author("Maksim").

-export([init/2, abonent/3]).

-include("abonents.hrl").

init(Req0, State)->
  HasBody = cowboy_req:has_body(Req0),
  Method = cowboy_req:method(Req0),
  Req = abonent(Method, HasBody, Req0),
  {ok, Req, State}.

abonent(<<"GET">>, Req0, _)->
  case cowboy_req:parse_qs(Req0) of
    [{<<"number">>, NumBinary}] ->
      list_to_integer(binary:bin_to_list(NumBinary)),
      {atomic, List_data} = database:get_abonent(list_to_integer(binary:bin_to_list(NumBinary))),
      req_reply:reply_abonent_data(List_data, Req0);

    _ ->
      req_reply:reply_error(<<"number">>, <<"Please enter abonent's number">>, Req0)
  end;

abonent(_, Req0, _)->
  req_reply:reply_404(Req0).
