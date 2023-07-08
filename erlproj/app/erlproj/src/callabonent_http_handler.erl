

-module(callabonent_http_handler).
-author("Maksim").
-export([init/2, call/2]).

-include("abonents.hrl").


init(Req0, State)->
  Method = cowboy_req:method(Req0),
  Req = call(Method, Req0),
  {ok, Req, State}.


call(<<"GET">>, Req0)->
  case cowboy_req:parse_qs(Req0) of
    [{<<"number">>, NumBinary}] ->
        list_to_integer(binary:bin_to_list(NumBinary)),
        {atomic, List_data} = database:get_abonent(list_to_integer(binary:bin_to_list(NumBinary))),
      case List_data of
        [] ->
          req_reply:reply_result(<<"Request number not found.">>, Req0);
        _ ->
          dialer:call(binary:bin_to_list(NumBinary)),
          req_reply:reply_result(<<"Request call started">>, Req0)
      end;
    _ ->
      req_reply:reply_error(<<"number">>, <<"Please enter request number">>, Req0)
  end;

call(_, Req0)->
  req_reply:reply_404(Req0).