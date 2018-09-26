
minAPs=1;

maxZones=getZone([]);
zFigure=[];
apResults=[];

for zz=1:maxZones
	zFigure(zz)=figure;
	title(['APs Zone ' num2str(zz)]);
	hold on
	apResults.(['Z' num2str(zz)])=[];
	apResults.(['Z' num2str(zz)]).avgTrace=[];
end

otherFields={'ML', 'DV', 'restMode', 'restMean', 'restMedian', 'restSD', ...
	'pulseI', 'pulseV', 'pulseRm', 'sagV', 'checkPulseRpeakMean', 'checkPulseRendMean'...
	};

for counter=1:length(csAllCells)
	newCell=csAllCells(counter);
	disp([newCell.mouseID '_' num2str(newCell.cellID)])
	aps=find(~isnan(newCell.nAP) & (newCell.traceQC) & ~isnan(newCell.pulseV) & ...
		newCell.nAP>=max(minAPs, 1)); % & (newCell.restMean<-50) & (newCell.restSD<5) & (newCell.checkPulseRpeak>100));
	
	if ~isempty(aps) 
		aps=aps(1);
		allFields=fieldnames(newCell.pulseAP{aps});
		
		zoneList=getZone(newCell);
		
		if isempty(find(zoneList==1, 1))
			zoneList=[1 zoneList];
		end
		
		for zz=zoneList
			if isempty(apResults.(['Z' num2str(zz)]).avgTrace)
				apResults.(['Z' num2str(zz)]).avgTrace=newCell.acq{aps}.data;
			else
				apResults.(['Z' num2str(zz)]).avgTrace=...
					apResults.(['Z' num2str(zz)]).avgTrace+newCell.acq{aps}.data;
			end
			
			
			figure(zFigure(zz));
			plot(newCell.acq{aps}.data);
		
			for fc=1:length(allFields)
				fns=allFields{fc};
				value=newCell.pulseAP{aps}.(fns)(1);
				if isfield(apResults.(['Z' num2str(zz)]), fns)
					apResults.(['Z' num2str(zz)]).(fns)(end+1)=value;
				else
					apResults.(['Z' num2str(zz)]).(fns)=value;
				end
			end

			for fc=1:length(otherFields)
				fns=otherFields{fc};
				value=newCell.(fns);
				if length(value)>1
					value=value(aps);
				end
				if isfield(apResults.(['Z' num2str(zz)]), fns)
					apResults.(['Z' num2str(zz)]).(fns)(end+1)=value;
				else
					apResults.(['Z' num2str(zz)]).(fns)=value;
				end
			end
		end
	end
end

for zz=1:maxZones
	apResults.(['Z' num2str(zz)]).avgTrace=...
		apResults.(['Z' num2str(zz)]).avgTrace / ...
		length(apResults.(['Z' num2str(zz)]).nAP);
	figure(zFigure(zz));
	[apResults.(['Z' num2str(zz)]).avgTraceRecalc, apResults.(['Z' num2str(zz)]).avgTraceSD]= ...
		phSummary_AvgSTDWindow(1);
	title(['APs Zone ' num2str(zz) ' AVG +/- SD']);
end

