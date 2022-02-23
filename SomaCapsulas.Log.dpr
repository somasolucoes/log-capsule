program SomaCapsulas.Log;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  SomaCapsulas.Log.Constants in 'SomaCapsulas.Log.Constants.pas',
  SomaCapsulas.Log.Exception in 'SomaCapsulas.Log.Exception.pas',
  SomaCapsulas.Log.Interfaces in 'SomaCapsulas.Log.Interfaces.pas',
  SomaCapsulas.Log.Message in 'SomaCapsulas.Log.Message.pas',
  SomaCapsulas.Log.Types in 'SomaCapsulas.Log.Types.pas',
  SomaCapsulas.Log.Source.Strategy.TextFile in 'source\strategy\SomaCapsulas.Log.Source.Strategy.TextFile.pas';

var
  LReadLnToWait: string;
begin
  try
    Writeln('SOMA Cápsulas - Log');
    Writeln(EmptyStr);
    Writeln('                    _,,......_                        ');
    Writeln('                 ,-''          `''--.                 ');
    Writeln('              ,-''  _              ''-.               ');
    Writeln('     (`.    ,''   ,  `-.              `.              ');
    Writeln('      \ \  -    / )    \               \              ');
    Writeln('       `\`-^^^, )/      |     /         :             ');
    Writeln('         )^ ^ ^V/            /          ''.           ');
    Writeln('         |      )            |           `.           ');
    Writeln('         9   9 /,--,\    |._:`         .._`.          ');
    Writeln('         |    /   /  `.  \    `.      (   `.`.        ');
    Writeln('         |   / \  \    \  \     `--\   )    `.`.___   ');
    Writeln('-hrr-   .;;./  ''   )   ''   )       ///''       `-"''');
    Writeln('        `--''   7//\    ///\                          ');
    Read(LReadLnToWait);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
