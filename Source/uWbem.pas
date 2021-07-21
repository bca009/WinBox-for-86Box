(*

    WinBox for 86Box - An alternative manager for 86Box VMs

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

unit uWbem;

interface

uses Windows, Classes, Variants, Generics.Collections, ComObj, ActiveX,
     WbemScripting_TLB;

type
  TWbemContext = class
  private
    FSWbemLocator: ISWbemLocator;
    FWMIService: ISWbemServices;
    FConnected: boolean;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property IsConnected: boolean read FConnected;
    property Service: ISWbemServices read FWMIService;
  end;

  TWbemQuery = class
  private
    FContext: TWbemContext;
    FOwnContext: boolean;

    FProperties: TStrings;
    FValues: TList<TArray<OleVariant>>;
    function GetCount: integer;
    function GetValues(I: integer): TArray<OleVariant>;
  protected
    FQuery: string;
    procedure Clear;
  public
    constructor Create(AContext: TWbemContext); reintroduce; virtual;
    destructor Destroy; override;

    procedure Refresh;

    function TryGetValue(const Index, PropIndex: integer; var Value: OleVariant): boolean; overload;
    function TryGetValue(const Index: integer; const AProperty: string; var Value: OleVariant): boolean; overload; inline;

    property IsOwnContext: boolean read FOwnContext;

    property Query: string read FQuery write FQuery;
    property Properties: TStrings read FProperties;

    property Values[I: integer]: TArray<OleVariant> read GetValues;
    property Count: integer read GetCount;
  end;

implementation

{ TWbemContext }

constructor TWbemContext.Create;
begin
  FConnected := false;
  try
    FSWbemLocator := CoSWbemLocator.Create;
    FWMIService := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '', '', '', 0, nil);
    FConnected := true;
  except
  end;
end;

destructor TWbemContext.Destroy;
begin
  FWMIService := nil;
  FSWbemLocator := nil;
  inherited;
end;

{ TWbemObject }

constructor TWbemQuery.Create(AContext: TWbemContext);
begin
  FOwnContext := not Assigned(AContext);
  if FOwnContext then
    FContext := TWbemContext.Create
  else
    FContext := AContext;

  FProperties := TStringList.Create;
  FValues := TList<TArray<OleVariant>>.Create;
end;

destructor TWbemQuery.Destroy;
begin
  FProperties.Free;
  Clear;

  FValues.Free;

  if FOwnContext then
    FContext.Free;

  inherited;
end;

function TWbemQuery.GetCount: integer;
begin
  Result := FValues.Count;
end;

function TWbemQuery.GetValues(I: integer): TArray<OleVariant>;
begin
  Result := FValues[I];
end;

procedure TWbemQuery.Clear;
var
  I, J: Integer;
begin
  for I := 0 to FValues.Count - 1 do
    for J := 0 to High(FValues[I]) do
      VarClear(FValues[I][J]);

  FValues.Clear;
end;

procedure TWbemQuery.Refresh;
var
  SWbemObjectSet: ISWbemObjectSet;
  SWbemObject: ISWbemObject;
  SWbemPropertySet: ISWbemPropertySet;

  evEnumObjs, evEnumProps: IEnumVARIANT;
  ovWmiObject, ovPropItem: OleVariant;

  dwDummy: Cardinal;

  I: integer;
  aovTemp: TArray<OleVariant>;
begin
  try
    SWbemObjectSet := FContext.Service.ExecQuery(
      FQuery, 'WQL', wbemFlagForwardOnly or wbemFlagReturnImmediately, nil);

    Clear;
    evEnumObjs := SWbemObjectset._NewEnum as IEnumVARIANT;
    while evEnumObjs.Next(1, ovWmiObject, dwDummy) = S_OK do begin
      SWbemObject := IUnknown(ovWmiObject) as ISWbemObject;
      SWbemPropertySet := SWbemObject.Properties_;

      if FProperties.Count = 0 then begin
        evEnumProps := SWbemPropertySet._NewEnum as IEnumVARIANT;

        while evEnumProps.Next(1, ovPropItem, dwDummy) = S_OK do begin
          FProperties.Add(ovPropItem.Name);
          VarClear(ovPropItem);
        end;
      end;

      SetLength(aovTemp, FProperties.Count);
      for I := 0 to FProperties.Count - 1 do
        aovTemp[I] := SWbemPropertySet.Item(FProperties[I], 0).Get_Value;
      FValues.Add(aovTemp);
    end;
  except
    Clear;
    raise;
  end;
end;

function TWbemQuery.TryGetValue(const Index: integer; const AProperty: string;
  var Value: OleVariant): boolean;
begin
  Result := TryGetValue(Index, FProperties.IndexOf(AProperty), Value);
end;

function TWbemQuery.TryGetValue(const Index, PropIndex: integer;
  var Value: OleVariant): boolean;
begin
  Value := Null;
  if (PropIndex >= 0) and (PropIndex < FProperties.Count) and
     (Index >= 0) and (Index < FValues.Count) then
        Value := FValues[Index][PropIndex];
  Result := not VarIsNull(Value);
end;

end.
