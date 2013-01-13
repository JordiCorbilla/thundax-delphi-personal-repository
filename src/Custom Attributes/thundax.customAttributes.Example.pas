//  Copyright (c) 2012-2013, Jordi Corbilla
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

unit thundax.customAttributes.Example;

interface

type
  TUserPasswordAttribute = class(TCustomAttribute)
  private
    FPassword: string;
    FUserName: string;
    Fresponse: Boolean;
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure Setresponse(const Value: Boolean);
  public
    constructor Create(aUserName: string; aPassword: string; aResponse : Boolean);
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property response : Boolean read Fresponse write Setresponse;
  end;

  TUserAgeAttribute = class(TCustomAttribute)
  private
    FAge: integer;
    FUserName: String;
    Fresponse: Boolean;
    procedure SetAge(const Value: integer);
    procedure SetUserName(const Value: String);
    procedure Setresponse(const Value: Boolean);
  public
    property UserName : String read FUserName write SetUserName;
    property Age : integer read FAge write SetAge;
    property response : Boolean read Fresponse write Setresponse;
    constructor Create(aUserName : string; aAge : Integer; aResponse : Boolean);
  end;

  TLogin = class(TObject)
  public
    function UserLogin(aUserName : string; aPassword : string) : Boolean;
    function fetchDatauser(aUserName : string) : Integer;
  end;

implementation

{ TUserPasswordAttribute }

constructor TUserPasswordAttribute.Create(aUserName, aPassword: string; aResponse : Boolean);
begin
  SetUserName(aUserName);
  SetPassword(aPassword);
  Setresponse(aResponse);
end;

procedure TUserPasswordAttribute.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TUserPasswordAttribute.Setresponse(const Value: Boolean);
begin
  Fresponse := Value;
end;

procedure TUserPasswordAttribute.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

{ TUserAgeAttribute }

constructor TUserAgeAttribute.Create(aUserName: string; aAge: Integer; aResponse : Boolean);
begin
  SetUserName(aUserName);
  SetAge(aAge);
  Setresponse(aResponse);
end;

procedure TUserAgeAttribute.SetAge(const Value: integer);
begin
  FAge := Value;
end;

procedure TUserAgeAttribute.Setresponse(const Value: Boolean);
begin
  Fresponse := Value;
end;

procedure TUserAgeAttribute.SetUserName(const Value: String);
begin
  FUserName := Value;
end;

{ TLogin }

function TLogin.fetchDatauser(aUserName: string): Integer;
var
  age : Integer;
begin
  //Fetching data from the user (test purposes)
  age := 0;
  if aUserName = 'User1' then
    age := 26;
  if aUserName = 'User2' then
    age := 27;
  if aUserName = 'User3' then
    age := 29;
  Result := age;
end;

function TLogin.UserLogin(aUserName, aPassword: string): Boolean;
var
  response : boolean;
begin
  //Test purposes
  response := false;
  if (aUserName = 'User1') and (aPassword = 'Password1') then
    response := true;
  if (aUserName = 'User2') and (aPassword = 'Password2') then
    response := true;
  if (aUserName = 'User3') and (aPassword = 'Password3') then
    response := true;
  Result := response;
end;

end.
