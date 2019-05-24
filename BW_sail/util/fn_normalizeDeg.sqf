private _deg = param [0,0, [0]];

while {_deg<0}do{_deg=_deg+360;};
while {_deg>=360}do{_deg=_deg-360;};
_deg;