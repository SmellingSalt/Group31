function gewicht=wgauss(fenstergroesse,schrittweite)

ensemble=round(fenstergroesse/schrittweite);

summe=0;

gewicht=gausswin(fenstergroesse);

base=gewicht(1);

if(base>gewicht(fenstergroesse)) 
	base=gewicht(fenstergroesse); 
end

gewicht=gewicht-base;

speicher=0;

for j=1:schrittweite
	for i=1:ensemble
		speicher=speicher+gewicht(fenstergroesse-(i-1)*schrittweite-(schrittweite-j));
	end 
	vorfaktor=1/speicher;
	for i=1:ensemble
		gewicht(fenstergroesse-(i-1)*schrittweite-(schrittweite-j))=gewicht(fenstergroesse-(i-1)*schrittweite-(schrittweite-j))*vorfaktor;
	end 
	speicher=0;
end



%plot(gewicht);
