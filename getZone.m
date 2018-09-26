function zone=getZone(newCell)
	if isempty(newCell) % this is a cludge - is empty comes in, return the max number of zones
		zone=4;
	else
		% use this for the CTB defined zone
		zoneLabel=newCell.Injection(1);

		% use this for the anatomically defined zone
		% if newCell.ML<=0
		% 	zoneLabel='M';
		% elseif newCell.ML<=400
		% 	zoneLabel='C';
		% else
		% 	zoneLabel='L';
		% end

		if zoneLabel=='M'
			zone=2;
		elseif zoneLabel=='C'
			zone=3;
		elseif zoneLabel=='L'
			zone=4;
		end
	end