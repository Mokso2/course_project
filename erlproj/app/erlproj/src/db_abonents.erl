
-module(db_abonents).
-author("Maksim").

-include("abonents.hrl").

-export([start/0, delete/2, gets/0, add/1, get/1]).

start() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  mnesia:create_table(abonents, [{type, bag}, {attributes, record_info(fields, abonents)}]).


get(Number) ->
  Fun = fun() ->
    mnesia:match_object({abonents, Number, '_'})
        end,
  mnesia:transaction(Fun).

add(Data) ->
  Fun = fun() ->
    mnesia:write(#abonents{num = maps:get(<<"num">>, Data), name = binary:bin_to_list(maps:get(<<"name">>, Data))})
        end,
  mnesia:transaction(Fun).

gets() ->
  Fun = fun() ->
    mnesia:match_object({abonents, '_', '_'})
        end,
  mnesia:transaction(Fun).

delete(Number, Name)->
  Fun = fun() ->
    mnesia:delete_object({abonents, Number, Name})
        end,
  mnesia:transaction(Fun).