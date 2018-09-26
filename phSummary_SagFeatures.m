
minAPs=1;

maxZones=getZone([]);
zFigure=[];
pulseAmp=-100;

for zz=1:maxZones
	zFigure(zz)=figure;
	title(['Sag Zone ' num2str(zz)]);
	hold on
	apResults.(['Z' num2str(zz)]).sagAvgTrace=[];
	apResults.(['Z' num2str(zz)]).sagV=[];	
end

for counter=1:length(csAllCells)
	newCell=csAllCells(counter);
	disp([newCell.mouseID '_' num2str(newCell.cellID)])
	aps=find((newCell.pulseI==pulseAmp) & (newCell.traceQC) & ~isnan(newCell.pulseV)); 
	
	if ~isempty(aps) 
		aps=aps(1);
		
		zoneList=getZone(newCell);
		
		if isempty(find(zoneList==1, 1))
			zoneList=[1 zoneList];
		end
		
		for zz=zoneList
			if isempty(apResults.(['Z' num2str(zz)]).sagAvgTrace)
				apResults.(['Z' num2str(zz)]).sagAvgTrace=newCell.acq{aps}.data;
			else
				apResults.(['Z' num2str(zz)]).sagAvgTrace=...
					apResults.(['Z' num2str(zz)]).sagAvgTrace+newCell.acq{aps}.data;
			end
			
			apResults.(['Z' num2str(zz)]).sagV(end+1)=newCell.sagV(aps);

			figure(zFigure(zz));
			plot(newCell.acq{aps}.data);
		end
	end
end

for zz=1:maxZones
	apResults.(['Z' num2str(zz)]).sagAvgTrace=...
		apResults.(['Z' num2str(zz)]).sagAvgTrace / ...
		length(apResults.(['Z' num2str(zz)]).sagV);
	figure(zFigure(zz));
	[apResults.(['Z' num2str(zz)]).sagAvgTraceRecalc, apResults.(['Z' num2str(zz)]).sagAvgTraceSD]= ...
		phSummary_AvgSTDWindow(1);
	title(['Sag Zone ' num2str(zz) ' AVG +/- SD']);
end

