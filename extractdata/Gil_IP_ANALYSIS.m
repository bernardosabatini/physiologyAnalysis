% the list of pulse amplitudes to keep and analyze.  It doesn't matter if
% there are entries here that are not used
bExact=[-100 -50 0 20 40 50 60 80 100 150 200 250];

% instead define bins by low and high
bLow=[-100 0 19 49 100 150 200 250 ];
bHigh=[-100 0 31 61 100 150 200 250 ];

% use the bins or the exact?
useExact=1;

if useExact
	pCount=length(bExact);
else
	pCount=length(bLow);
end

maxZones=4;
avgV=zeros(maxZones,pCount);
avgI=zeros(maxZones,pCount);
avgA=zeros(maxZones,pCount);
avgN=zeros(maxZones,pCount);

stdV=zeros(maxZones,pCount);
stdI=zeros(maxZones,pCount);
stdA=zeros(maxZones,pCount);
stdN=zeros(maxZones,pCount);

allCounter=0;
for runThru=1:2 % first run calcualtes the averages.  Second does the Standard Deviation
	for counter=1:length(csAllCells)
		newCell=csAllCells(counter);
		disp([newCell.mouseID ' ' newCell.cellID])
		aps=newCell.nAP;
		aps(isnan(aps))=0;

		if sum(aps)>10
			for bCounter=1:pCount
				ff1=[];
				if useExact
					ff=find((newCell.pulseI==bExact(bCounter)));
					if ~isempty(ff)
						ff1=ff(1);
					end
				else
					ff=find((newCell.pulseI>=bLow(bCounter)) & (newCell.pulseI<=bHigh(bCounter)));
					if ~isempty(ff)
						ff1=ff(1);
					end
				end
				if ~isempty(ff1)  && ~isnan(newCell.pulseV(ff1)) % && ...
				%	(newCell.restMean(ff1)<-50) && (newCell.restMea n(ff1)>-80) && (newCell.restSD(ff1)<5)...
				%	&& (newCell.checkPulseRpeak(ff1)>100)

					% write the function getZone to subdivide cells into
					% different classes.  Return an integer of 2 or greater
					% to specify the zone.  
					% 1 is used to store all the cells
					% just return 1 if there is no sub-dividing cells
					zone=getZone(newCell);

					if zone==1
						zoneList=1;
					else
						zoneList=[1 zone];
					end
					
					for ind=zoneList  % run through it once to put in the ALL pile and then in zone specific pile
						if runThru==1 % first time through calculate the average
							avgV(ind, bCounter)=avgV(ind, bCounter)+newCell.pulseV(ff1);
							avgI(ind, bCounter)=avgI(ind, bCounter)+newCell.pulseI(ff1);
							avgA(ind, bCounter)=avgA(ind, bCounter)+newCell.nAP(ff1);
							avgN(ind, bCounter)=avgN(ind, bCounter)+1;
						else % first time through calculate the standard deviation
							stdV(ind, bCounter)=stdV(ind, bCounter)+(newCell.pulseV(ff1)-avgV(ind, bCounter))^2;
							stdI(ind, bCounter)=stdI(ind, bCounter)+(newCell.pulseI(ff1)-avgI(ind, bCounter))^2;
							stdA(ind, bCounter)=stdA(ind, bCounter)+(newCell.nAP(ff1)-avgA(ind, bCounter))^2;
							stdN(ind, bCounter)=stdN(ind, bCounter)+1;
						end
					end
				end
			end
		end
	end
	
	if runThru==1
		avgI=avgI./avgN;
		avgV=avgV./avgN;
		avgA=avgA./avgN;
	else
		stdI=(stdI./stdN).^(0.5);
		stdV=(stdV./stdN).^(0.5);
		stdA=(stdA./stdN).^(0.5);
		semI=stdI./(stdN.^(0.5));
		semV=stdV./(stdN.^(0.5));
		semA=stdA./(stdN.^(0.5));
	end
end

figure;
for c=1:maxZones
	vv=avgV(c,:);
	ii=avgI(c,:);
	vv(isnan(vv))=[];
	ii(isnan(ii))=[];
	plot(ii, vv)
	hold on
	vvs=stdV(c,:);
	iis=stdI(c,:);
	vvs(isnan(vvs))=[];
	iis(isnan(iis))=[];
	errorbar(ii, vv, vvs, vvs)
end

figure;
for c=1:maxZones
	aa=avgA(c,:);
	ii=avgI(c,:);
	aa(isnan(aa))=[];
	ii(isnan(ii))=[];
	
	plot(ii, aa)
	hold on
	aas=stdA(c,:);
	iis=stdI(c,:);
	aas(isnan(aas))=[];
	iis(isnan(iis))=[];
	errorbar(ii, aa, aas, aas)	
end

figure;
for c=1:maxZones
	aa=avgA(c,:);
	vv=avgV(c,:);
	aa(isnan(aa))=[];
	vv(isnan(vv))=[];
	
	plot(vv, aa)
	hold on
	aas=stdA(c,:);
	vvs=stdV(c,:);
	aas(isnan(aas))=[];
	vvs(isnan(vvs))=[];
	errorbar(vv, aa, aas, aas)	
end