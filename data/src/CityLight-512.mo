package CityLight
  function incidentFlux
    input Modelica.Units.SI.Angle latitude "Latitude";
    input Modelica.Units.SI.Angle azimuth "House orientation";
    input Modelica.Units.SI.Angle declination "Declination";
    input Modelica.Units.SI.Angle solarHour "Solar hour angle";
    input Modelica.Units.SI.HeatFlux DNIz = 1000 "Solar flux when the sun is at zenith";
    input Real eta = 0.7 "Transmitted irradiation at zenith";
    output Modelica.Units.SI.HeatFlux phi "Solar flux hitting the surface";
    
  protected
    Real latSin "Sine of latitude";
    Real latCos "Cosine of latitude";
    Real aziSin "Sine of azimuth";
    Real aziCos "Cosine of azimuth";
    Real decSin "Sine of declination";
    Real decCos "Cosine of declination";
    Real solSin "Sine of solar hour angle";
    Real solCos "Cosine of solar hour angle";
    Real incidenceAngle "Light incidence angle";
    Real zenithAngleCos "Cosine of zenith angle";
    Real DNI "Direct normal irradiation";
    constant Real epsilon = 0.001;
    
  algorithm
    latSin := sin(latitude);
    latCos := cos(latitude);
    aziSin := sin(azimuth);
    aziCos := cos(azimuth);
    decSin := sin(declination);
    decCos := cos(declination);
    solSin := sin(solarHour);
    solCos := cos(solarHour);
    
    incidenceAngle := acos(aziSin*decCos*solSin + aziCos*(decCos*solCos*latSin - decSin*latCos));
    zenithAngleCos := latCos*decCos*solCos + latSin*decSin;
    
    if zenithAngleCos > epsilon then
      // Sun is above the horizon.
      DNI := DNIz*eta^(1/zenithAngleCos - 1);
    else
      // Sun is below the horizon.
      DNI := 0;
    end if;
    
    phi := DNI * max(cos(incidenceAngle), 0);
  end incidentFlux;

  model House
    parameter Modelica.Units.SI.Angle latitude(displayUnit = "deg") "Latitude";
    parameter Modelica.Units.SI.Angle declination(displayUnit = "deg") "Declination";
    parameter Modelica.Units.SI.Angle azimuth(displayUnit = "deg") "Where the window is facing (0 = north, 90 = east, 180 = south, 270 = west)";
    parameter Real reflectionFactor "How much the window reflects the incident light (1 = maximum reflection)";
    Modelica.Units.SI.Area windowSize "Window size";
    constant Integer secondsInADay = 24*60*60;
    Modelica.Units.SI.HeatFlux phi "Solar flux coming inside the house";
    Modelica.Units.SI.Power power(displayUnit = "W");
  equation
    phi = incidentFlux(latitude, azimuth, declination, time*2*Modelica.Constants.pi/secondsInADay - Modelica.Constants.pi)*(1 - reflectionFactor);
    
    power = phi * windowSize;
  end House;

  model Block
    parameter Integer N = 512;
    parameter Modelica.Units.SI.Area windowSize = 1;
    
    parameter Real latitude;
    parameter Real declination;
    
    parameter Real azimuth[N] = {(i - 1) * 360 / N for i in 1:N} * Modelica.Constants.pi / 180;
    
    House brightHouses[N](each latitude = latitude , each declination = declination, azimuth = azimuth, each reflectionFactor = 0.05, each windowSize = windowSize);
    House almostBrightHouses[N](each latitude = latitude, each declination = declination, azimuth = azimuth, each reflectionFactor = 0.2, each windowSize = windowSize);
    House almostDarkHouses[N](each latitude = latitude, each declination = declination, azimuth = azimuth, each reflectionFactor = 0.8, each windowSize = windowSize);
    House darkHouses[N](each latitude = latitude, each declination = declination, azimuth = azimuth, each reflectionFactor = 0.95, each windowSize = windowSize);
  end Block;

  model City
    parameter Modelica.Units.SI.Angle latitude = 63.419923*Modelica.Constants.pi/180;
    parameter Modelica.Units.SI.Angle declination = 23*Modelica.Constants.pi/180;
    
    Block bigHouses(latitude = latitude, declination = declination, windowSize = 5);
    Block smallHouses(latitude = latitude, declination = declination, windowSize = 3);
    
    annotation(
      experiment(StartTime = 0, StopTime = 86400, Tolerance = 1e-06, Interval = 60));
  end City;
end CityLight;
