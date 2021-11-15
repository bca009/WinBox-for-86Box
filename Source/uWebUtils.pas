(*

    WinBox Reloaded R2 - An universal GUI for many emulators

    Copyright (C) 2020, Laci bá'

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

*)

unit uWebUtils;

interface

uses Windows, Winsock, WinINet, SysUtils, Classes, DateUtils, IdHttp;

type
  TDownloader = class
  private
    FProgress: TNotifyEvent;
    FBytesRead: Int64;
    FDownloading: boolean;
  public
    constructor Create;
    function Download(URL, User, Pass: string;
                Header: PChar; const HeaderLen: LongWord;
                Stream: TStream; const Port: LongWord = INTERNET_DEFAULT_HTTPS_PORT): boolean; overload;
    function Download(URL, User, Pass: string;
                Stream: TStream; const Port: LongWord = INTERNET_DEFAULT_HTTPS_PORT): boolean; overload; inline;
    function Download(URL, User, Pass, FileName: string;
                const Port: LongWord = INTERNET_DEFAULT_HTTPS_PORT): boolean; overload;
    property OnProgress: TNotifyEvent read FProgress write FProgress;
    property BytesRead: Int64 read FBytesRead;
    property Downloading: boolean read FDownloading;
  end;

const
  iphlpapi = 'iphlpapi.dll';

type
  IP_OPTION_INFORMATION = record
    Ttl: UCHAR;
    Tos: UCHAR;
    Flags: UCHAR;
    OptionsSize: UCHAR;
    OptionsData: PUCHAR;
  end;
  PIP_OPTION_INFORMATION = ^IP_OPTION_INFORMATION;
  TIpOptionInformation = IP_OPTION_INFORMATION;
  PIpOptionInformation = PIP_OPTION_INFORMATION;

  ICMP_ECHO_REPLY = record
    Address: u_long;
    Status: ULONG;
    RoundTripTime: ULONG;
    DataSize: USHORT;
    Reserved: USHORT;
    Data: LPVOID;
    Options: IP_OPTION_INFORMATION;
  end;
  PICMP_ECHO_REPLY = ^ICMP_ECHO_REPLY;
  TIcmpEchoReply = ICMP_ECHO_REPLY;
  PIcmpEchoReply = PICMP_ECHO_REPLY;

function IcmpCreateFile: THandle; stdcall; external iphlpapi;
function IcmpCloseHandle(icmpHandle: THandle): Boolean; stdcall; external iphlpapi;
function IcmpSendEcho(IcmpHandle: THandle;
  DestinationAddress: u_long; RequestData: Pointer;
  RequestSize: Smallint; RequestOptions: pointer; ReplyBuffer: Pointer;
  ReplySize: DWORD; Timeout: DWORD): DWORD; stdcall; external iphlpapi;

//URL: tetszõleges
function httpsGet(URL: string; Stream: TStream): boolean; overload;
function httpsGet(URL, FileName: string): boolean; overload;
function httpGet(AURL: string; Stream: TStream): boolean; overload;
function httpGet(AURL, FileName: string): boolean; overload;
function httpsGet(const URL: string): string; overload;

function httpsGetEx(const URL: string; Headers: string): string;

//URL: pl. http://ci.86box.net/job/86Box-Dev
function jenkinsLastBuild(URL: string): integer;
function jenkinsGetDate(URL: string; const Build: integer): TDateTime;
function jenkinsGetChangelog(URL: string; const Build: integer): TStringList;
function jenkinsGetBuild(URL: string; const Build: integer): TStringList;
function jenkinsCheckUpdate(URL: string; const LocalDate: TDateTime): boolean;

//URL: pl. https://github.com/86Box/roms
function gitClone(URL: string; Stream: TStream): boolean; overload;
function gitClone(URL, FileName: string): boolean; overload;

function XmlFind(const Tag, XML: string): string;
function XmlFindEx(const Tag, XML: string; var Offset: integer): string;
procedure XmlFindAll(const Tag, XML: string; List: TStringList);

//Ping (from szStart Reloaded)
function ResolveHost(const Host: String; out HostName: String): u_long;
function IPAddrToStr(const Address: u_long): string;
function Ping(const Address: u_long; const Timeout: Cardinal = 1000): DWORD;

//Internetelérés ellenõrzése
function ExtractHost(const URL: string): string;
function CheckForAccess(const URL: string): boolean;

var
  Downloader: TDownloader;
  DownloadProgress: TNotifyEvent = nil;

implementation

uses NetworkList_TLB;

var
  IcmpInitializated: boolean = false;
  IcmpHandle: THandle;

  WSAData: TWSAData = ();

resourcestring
  SJenkinsGetXML = '%s/%d/api/xml';
  SJenkinsDownload = '%s/%d/artifact/%s';
  SJenkinsLastBuild = '%s/lastSuccessfulBuild/buildNumber';
  SJenkinsGetTimeStamp = '%s/%d/api/xml?wrapper=changes&tree=timestamp';
  SJenkinsGetComment = '%s/%d/api/xml?wrapper=changes&xpath=//changeSet//comment';

function ExtractHost(const URL: string): string;
var
  P, Q: integer;
begin
  P := pos('//', URL);
  if P = 0 then
    P := pos('\\', URL);

  if P = 0 then
    Result := URL
  else begin
    Q := pos('/', URL, P + 2);
    if Q = 0 then
      Q := pos('\', URL, P + 2);

    if Q = 0 then
      Result := Copy(URL, P + 2, MaxInt)
    else
      Result := Copy(URL, P + 2, Q - P - 2);
  end;
end;

function CheckForAccess(const URL: string): boolean;
var
  Network: INetworkListManager;
  IPAddr: u_long;
  HostName: string;
begin
  Network := CoNetworkListManager.Create;
  if Assigned(Network) then
    Result := Network.IsConnectedToInternet
  else
    Result := false;

  Network := nil;

  if not Result then begin
    IPAddr := ResolveHost(ExtractHost(URL), HostName);
    Result := IPAddr <> u_long(INADDR_NONE);
    //if Result then
    //  Result := Ping(IPAddr) <> DWORD(-1);
  end;
end;

function ResolveHost(const Host: String; out HostName: String): u_long;
var
  Data: PHostEnt;
type
  PU_LONG = ^u_long;
begin
  Result := u_long(INADDR_NONE);
  HostName := '';

  if (Host <> '') and IcmpInitializated then begin
     Result := Inet_addr(PAnsiChar(AnsiString(Host)));

     if Result = u_long(INADDR_NONE) then begin
       Data := GetHostByName(PAnsiChar(AnsiString(Host)));
       if Assigned(Data) then begin
         Result := PU_LONG(Data^.h_addr_list^)^;
         HostName := String(AnsiString(Data^.h_name));
       end;
     end
     else begin
       Data := GetHostByAddr(@Result, SizeOf(u_long), AF_INET);
       if Assigned(Data) then
         HostName := String(AnsiString(Data^.h_name));
     end;
   end;
end;

function IPAddrToStr(const Address: u_long): string;
begin
  Result := String(AnsiString(Inet_ntoa(TInAddr(Address))));
end;

function Ping(const Address: u_long; const Timeout: Cardinal): DWORD;
var
  rep: array [1..32] of DWORD;
begin
  Result := DWORD(-1);
  if (not IcmpInitializated) or (IcmpHandle = INVALID_HANDLE_VALUE) then
    exit;

  if IcmpSendEcho(IcmpHandle, Address, nil, 0, nil, @rep, 128, Timeout) = 0 then
    Result := DWORD(-1)
  else
    Result := PIcmpEchoReply(@rep[1])^.RoundTripTime;
end;

function jenkinsCheckUpdate(URL: string; const LocalDate: TDateTime): boolean;
var
  Build: integer;
begin
  Build := jenkinsLastBuild(URL);
  if Build <> -1 then
    Result := CompareDate(LocalDate, jenkinsGetDate(URL, Build)) < 0
  else
    Result := false;
end;

function jenkinsLastBuild(URL: string): integer;
var
  Temp: string;
begin
  Temp := httpsGet(format(SJenkinsLastBuild, [URL]));
  if (Temp = '') or not TryStrToInt(Temp, Result) then
    Result := -1;
end;

function jenkinsGetDate(URL: string; const Build: integer): TDateTime;
var
  UnixTime: uint64;
begin
  if not TryStrToUInt64(
    XmlFind('timestamp', httpsGet(format(SJenkinsGetTimeStamp, [URL, Build]))), UnixTime) then
      UnixTime := 0;

  Result := UnixToDateTime(UnixTime div 1000, false);
end;

function jenkinsGetChangelog(URL: string; const Build: integer): TStringList;
var
  Temp: TStringList;
  S: string;
begin
  Temp := TStringList.Create;
  Result := TStringList.Create;
  try
    XmlFindAll('comment',
      httpsGet(format(SJenkinsGetComment, [URL, Build])), Temp);

    for S in Temp do
      ExtractStrings([#10], [], PChar(S), Result);
  finally
    Temp.Free;
  end;
end;

function jenkinsGetBuild(URL: string; const Build: integer): TStringList;
var
  I: integer;
begin
  Result := TStringList.Create;
  XmlFindAll('fileName',
     httpsGet(format(SJenkinsGetXML, [URL, Build])), Result);

  for I := 0 to Result.Count - 1 do
    Result[I] := format(SJenkinsDownload, [URL, Build, Result[I]]);
end;

function httpsGetEx(const URL: string; Headers: string): string; overload;
var
  AStream: TStringStream;
begin
  Headers := Headers + #0;
  AStream := TStringStream.Create;
  try
    if Downloader.Download(URL, '', '', @Headers[1], length(Headers), AStream) then
      Result := AStream.DataString
    else
      Result := '';
  finally
    AStream.Free;
  end;
end;

function httpsGet(const URL: string): string; overload;
var
  AStream: TStringStream;
begin
  AStream := TStringStream.Create;
  try
    if httpsGet(URL, AStream) then
      Result := AStream.DataString
    else
      Result := '';
  finally
    AStream.Free;
  end;
end;

function httpGet(AURL: string; Stream: TStream): boolean; overload;
var
  P: int64;
begin
  with TIdHttp.Create(nil) do begin
    P := Stream.Position;
    Get(AURL, Stream);
    Result := P <> Stream.Position;
    Free;
  end;
end;

function httpGet(AURL, FileName: string): boolean; overload;
var
  F: TStream;
begin
  F := TFileStream.Create(FileName, fmCreate);
  Result := httpGet(AURL, F);
  F.Free;
end;

function httpsGet(URL: string; Stream: TStream): boolean; overload;
begin
  Result := Downloader.Download(URL, '', '', Stream);
end;

function httpsGet(URL, FileName: string): boolean; overload;
var
  F: TStream;
begin
  F := TFileStream.Create(FileName, fmCreate);
  Result := httpsGet(URL, F);
  F.Free;
end;

function gitClone(URL: string; Stream: TStream): boolean; overload;
begin
  Result := httpsGet(URL + '/archive/master.zip', Stream);
end;

function gitClone(URL, FileName: string): boolean; overload;
begin
  Result := httpsGet(URL + '/archive/master.zip', FileName);
end;

function XmlFind(const Tag, XML: string): string;
var
  S, E: integer;
begin
  S := Pos('<' + Tag + '>', XML);
  if S = 0 then
    exit('')
  else
    S := S + length(Tag) + 2;

  E := Pos('</' + Tag + '>', XML, S);
  if E = 0 then
    exit('');

  Result := Copy(XML, S, E - S);
end;

function XmlFindEx(const Tag, XML: string; var Offset: integer): string;
var
  S, E: integer;
begin
  S := Pos('<' + Tag + '>', XML, Offset);
  if S = 0 then
    exit('')
  else
    S := S + length(Tag) + 2;

  E := Pos('</' + Tag + '>', XML, S);
  if E = 0 then
    exit('');

  Result := Copy(XML, S, E - S);
  Offset := E;
end;

procedure XmlFindAll(const Tag, XML: string; List: TStringList);
var
  I: integer;
  S: string;
begin
  I := 1;
  S := XmlFindEx(Tag, XML, I);
  while S <> '' do begin
    List.Add(S);
    S := XmlFindEx(Tag, XML, I);
  end;
end;

{ TDownloader }

function TDownloader.Download(URL, User, Pass: string;
  Header: PChar; const HeaderLen: LongWord;
  Stream: TStream; const Port: LongWord): boolean;
const
  BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
begin
   hSession := InternetOpen('', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0) ;
   if hSession = nil then
     exit(false);

   InternetConnect(hSession, PChar(URL), Port, PChar(User), PChar(Pass),
     INTERNET_SERVICE_HTTP, 0, 0);

  try
    hURL := InternetOpenURL(hSession, PChar(URL), Header, HeaderLen, 0, 0);

    if hURL = nil then begin
      InternetCloseHandle(hSession);
      raise Exception.Create(
        SysErrorMessage(GetLastError, GetModuleHandle('wininet.dll')));
    end;

    FBytesRead := 0;
    FDownloading := true;
    try
      try
        repeat
          InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
          Stream.Write(Buffer, BufferLen);
          inc(FBytesRead, BufferLen);

          if Assigned(FProgress) then
            FProgress(Self);
        until BufferLen = 0;
      finally
        Result := True;
      end;
    finally
      InternetCloseHandle(hURL)
    end
  finally
    InternetCloseHandle(hSession);

    FDownloading := false;
    if Assigned(FProgress) then
      FProgress(Self);
  end;
end;

constructor TDownloader.Create;
begin
  FProgress := DownloadProgress;
  FBytesRead := 0;
  FDownloading := false;
end;

function TDownloader.Download(URL, User, Pass, FileName: string;  const Port: LongWord): boolean;
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  Result := Download(URL, User, Pass, S, Port);
  S.Free;
end;

function TDownloader.Download(URL, User, Pass: string; Stream: TStream;
  const Port: LongWord): boolean;
begin
  Result := Download(URL, User, Pass, nil, 0, Stream, Port);
end;

initialization
  Downloader := TDownloader.Create;

  IcmpInitializated := WSAStartup($101, WSAData) = 0;

  IcmpHandle := IcmpCreateFile;
  IcmpInitializated := IcmpInitializated and (IcmpHandle <> INVALID_HANDLE_VALUE);

finalization
  Downloader.Free;

   if IcmpInitializated then
     IcmpCloseHandle(IcmpHandle);
   if WSAData.wVersion <> 0 then
     WSACleanup;

end.
