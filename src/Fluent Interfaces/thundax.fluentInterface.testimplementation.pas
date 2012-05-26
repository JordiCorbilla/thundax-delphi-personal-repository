//  Copyright (c) 2012, Jordi Corbilla
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  - Neither the name of this library nor the names of its contributors may be
//    used to endorse or promote products derived from this software without
//    specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.

unit thundax.fluentInterface.testimplementation;

interface

uses
  Generics.collections, Generics.Defaults;

type
  TQueryImplementation = class(TObject)
    function GetIntegerListQueryValues() : TList<Integer>;
    function GetStringListQueryValues() : TList<String>;
  end;


implementation

uses
  thundax.fluentInterface.example, AnsiStrings, Windows;

{ TQueryImplementation }

function TQueryImplementation.GetIntegerListQueryValues: TList<Integer>;
var
  IqueryList : IQueryList<Integer, Boolean>;
  item : integer;
begin
  Result := TList<Integer>.Create;
  IqueryList := TQueryList<Integer, Boolean>
    .New()
    .FillList(function ( list : TList<Integer> ) : Boolean
              var k : integer;
              begin
                for k := 0 to 100 do
                  list.Add(Random(100));
                result := true;
              end);

  //Display filtered values
  for item in IqueryList
    .Select(function ( list : TList<Integer> ) : TList<Integer>
              var
                k : integer;
                selectList : TList<Integer>;
              begin
                selectList := TList<Integer>.Create;
                for k := 0 to list.Count-1 do
                begin
                  if Abs(list.items[k]) > 0 then
                    selectList.Add(list.items[k]);
                end;
                list.Free;
                result := selectList;
              end)
    .Where(function ( i : integer) : Boolean
          begin
            result := (i > 50);
          end)
    .Where(function ( i : integer) : Boolean
          begin
            result := (i < 75);
          end)
    .OrderBy(TComparer<integer>.Construct(
         function (const L, R: integer): integer
         begin
           result := L - R; //Ascending
         end
     )).Distinct.List do
          result.add(item);
end;

function TQueryImplementation.GetStringListQueryValues: TList<String>;
const
   Chars = '1234567890ABCDEFGHJKLMNPQRSTUVWXYZ!';
var
  S: string;
  IqueryList : IQueryList<String, Boolean>;
  item : String;
begin
  result := TList<String>.Create;
  //Fill up the list with random strings
  IqueryList := TQueryList<String, Boolean>
    .New
    .FillList(function ( list : TList<String> ) : Boolean
              var
                k : integer;
                l : Integer;
              begin
                Randomize;
                for k := 0 to 100 do
                begin
                  S := '';
                  for l := 1 to 8 do
                    S := S + Chars[(Random(Length(Chars)) + 1)];
                  list.Add(S);
                end;
                result := true;
              end);
  //Query the list and retrieve all items which contains 'A'
  for item in IqueryList.Where(function ( i : string) : Boolean
          begin
            result := (Pos('A', i) > 0);
          end).Distinct.List do
    result.add(item);

end;

end.
