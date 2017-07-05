library WeatherAPI;

{ Author: Halil Han Badem
  Company: Bi'Coder
  Date: 17/06/2017 14:57

    NOTE: Thank you so much, my family.}


uses
  System.SysUtils,
  System.Classes,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  Math,
  WeatherClass in 'WeatherClass.pas';

{$R *.res}


type
  TWeatherAPI = class(TInterfacedObject, WeatherAPIModule)
 protected
    Function WTemperature(APIID: String; City: String): String;
    Function WForecast(APIID: String; City: String): String;
    Function Parse(text, sol, sag: string): String;
end;



function TWeatherAPI.Parse(text, sol, sag: string): String;    /// Function Author: Ali Zairov
begin
  Delete(text, 1, Pos(sol, text) + Length(sol) - 1);
  Result := Copy(text, 1, Pos(sag, text) - 1);
end;


Function TWeatherAPI.WTemperature(APIID: String; City: String): String;
var
  XML: TStringList;
  Http: TIdHTTP;
  Matematik: Real;
  Kelvin: String;
begin
  XML := TStringList.Create;
  Http := TIdHTTP.Create(Nil);
  XML.Text := Http.Get('http://api.openweathermap.org/data/2.5/weather?q='+City+'&mode=xml&appid='+APIID);
  Kelvin := Copy(Parse(XML.Strings[1], '<temperature value="', '"'), 0, 3);
  Matematik := StrToInt(Kelvin) - 273;
  Result := FloatToStr(Matematik);
end;


Function TWeatherAPI.WForecast(APIID: String; City: String): String;
var
  XML: TStringList;
  Http: TIdHTTP;
  HavaDurum: String;
begin
  XML := TStringList.Create;
  Http := TIdHTTP.Create(Nil);
  XML.Text := Http.Get('http://api.openweathermap.org/data/2.5/weather?q='+City+'&mode=xml&appid='+APIID);
  HavaDurum := Parse(XML.Strings[1], '<weather number="', '" icon="');
  Delete(HavaDurum, 1, 12);
  Result := HavaDurum;
end;


Function WeatherApp: WeatherAPIModule; stdcall; export;
begin
  Result := TWeatherAPI.Create;
end;


Exports WeatherApp;

begin
end.
