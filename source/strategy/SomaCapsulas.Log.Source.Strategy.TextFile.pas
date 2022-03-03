unit SomaCapsulas.Log.Source.Strategy.TextFile;

interface

uses
  System.Classes, System.SysUtils, SomaCapsulas.Log.Interfaces, SomaCapsulas.Log.Constants;

type
  TLogStrategyTextFile = class(TInterfacedObject, ILogStrategy)
  private
    FFileNameWithPath: string;
    FMaxFileSize: Integer;
    function GetLogDirectory: string;
    function GetLogFileName: string;
    function GetFileSize(AFileNameWithPath: string): Int64;
  protected
    class var Lock: TMultiReadExclusiveWriteSynchronizer;
  public
    property LogDirectory: string read GetLogDirectory;
    property LogFileName: string read GetLogFileName;
    procedure Generate(AText: string);
    constructor Create(AFileNameWithPath: string = ''; AMaxFileSize: Integer = LOG_STRATEGY_TEXT_MAX_FILE_SIZE);
    class constructor Create;
    class destructor Destroy;
  end;

implementation

uses
  System.StrUtils, Math, System.IOUtils;

{ TLogStrategyTextFile }

class constructor TLogStrategyTextFile.Create;
begin
  Lock := TMultiReadExclusiveWriteSynchronizer.Create;
end;

class destructor TLogStrategyTextFile.Destroy;
begin
  Lock.Free;
  inherited;
end;

constructor TLogStrategyTextFile.Create(AFileNameWithPath: string; AMaxFileSize: Integer);
begin
  Self.FFileNameWithPath := AFileNameWithPath;
  if Self.FFileNameWithPath.IsEmpty then
  begin
    Self.FFileNameWithPath :=
      IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(ZeroValue))) + LOG_STRATEGY_TEXT_FILE_NAME;
  end;
  Self.FMaxFileSize := AMaxFileSize;
end;

procedure TLogStrategyTextFile.Generate(AText: string);
var
  LFileHandle: TextFile;
  LExceededSizeLimit: Boolean;
begin
  TDirectory.CreateDirectory(Self.LogDirectory);
  AssignFile(LFileHandle, Self.FFileNameWithPath);
  Lock.BeginWrite;
  try
    LExceededSizeLimit := (GetFileSize(Self.FFileNameWithPath) > Self.FMaxFileSize);
    if ((not FileExists(Self.FFileNameWithPath)) or LExceededSizeLimit) then
      Rewrite(LFileHandle)
    else
      Append(LFileHandle);
    WriteLn(LFileHandle, AText);
  finally
    Lock.EndWrite;
    Flush(LFileHandle);
    CloseFile(LFileHandle);
  end;
end;

function TLogStrategyTextFile.GetFileSize(AFileNameWithPath: string): Int64;
var
 SearchRec: TSearchRec;
begin
  Result := ZeroValue;
  if FindFirst(Self.FFileNameWithPath, faAnyFile, SearchRec) = ZeroValue then
  begin
    Result := SearchRec.Size;
    FindClose(SearchRec);
  end;
end;

function TLogStrategyTextFile.GetLogDirectory: string;
begin
  Result := ExtractFileDir(Self.FFileNameWithPath);
  Result := IfThen(Result.IsEmpty, ExtractFileDir(ParamStr(ZeroValue)), Result);
  Result := IncludeTrailingPathDelimiter(Result);
end;

function TLogStrategyTextFile.GetLogFileName: string;
begin
  Result := ExtractFileName(Self.FFileNameWithPath);
end;

end.
