function [ outstruct ] = erppeakinterval( INERP, varargin )
%   Extracts the mean amplitude surrounding the peak latency for each
%   channel in the interval period specified. Accepts either a vector of
%   latencies or can directly call geterpvalues() from ERPLAB to find the latency of 
%   the relative-to-baseline peak value between two specified latencies.
%
%   1   Input ERP dataset
%   2   Either specify:
%       a    'Latencies' - Vector of peak latency values in ms.
%        or
%       a    'Window' - Window period in ms to identify peaks in.
%       b    'Polarity' - [ 'Positive' (default) | 'Negative' ] Peak deflection direction.
%       c    'Neighborhood' - Number of points in the peak's neighborhood (one-side). Default is 9.
%   3   Additional parameters:
%       a    'Channels' - Vector of channel indices to use. Default is all channels. Channel labels can alternatively be provided {'FZ', 'CZ', 'PZ'}.
%       b    'Interval' - 1x2 matrix specifying the interval period in ms.   Default is [ 0 0 ].
%       c    'Bin' - ERP Bin to use. Default is 1.
%       d    'Label' - Label to apply to peaks.
%       
%   Returns a structure containing: 
%
%       1   channel: channel labels
%       2   channelnumber: channel numbers
%       3   amplitude: mean interval amplitude
%       4   error: mean interval amplitude error
%       5   latency: peak latency values
%       6   label: label for peaks
%
%   Example Code:
%
%       ERP.peaks.P3 = erppeakinterval(ERP, 'Label', 'P3', 'Window', [ 300 600 ], 'Polarity', 'Positive', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', 1:ERP.nchan);
%
%   or
%
%       ERP.peaks.P3 = erppeakinterval(ERP, 'Label', 'P3', 'Window', [ 300 600 ], 'Polarity', 'Positive', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', {'FZ', 'CZ', 'PZ'});
%
%   or
%
%       ALLERP = pop_geterpvalues( ERP, [ 300 600 ], 1, 1:ERP.nchan, 'Measure', 'peaklatbl', 'Peakpolarity', 'positive', 'Neighborhood', 9, 'Resolution', 6, 'SendtoWorkspace', 'on');
%       ERP.peaks.P3 = erppeakinterval(ERP, 'Label', 'P3', 'Latencies', ERP_MEASURES, 'Interval', [ -25 25 ], 'Channels', 1:ERP.nchan);
%
%   Multi Component Example: it is also possible to feed multiple components in and have
%       the function correct the latency windows based upon when the earlier components occured to prevent peak overlap.
%
%       % returns ERP.peaks.N2 and ERP.peaks.P3
%       ERP.peaks = erppeakinterval(ERP,{... 
%           {'Label', 'N2', 'Window', [ 150 400 ], 'Polarity', 'Negative', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', 1:ERP.nchan};...
%           {'Label', 'P3', 'Window', [ 300 600 ], 'Polarity', 'Positive', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', 1:ERP.nchan}...
%           });
%
%   or
%
%       % returns ERP.peaks.N2
%       ERP.peaks = erppeakinterval(ERP,{... 
%           {'Label', 'N2', 'Window', [ 150 360 ], 'Polarity', 'Negative', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', { 'F7', 'F5', 'F3', 'F1', 'FZ', 'F2', 'F4', 'F6', 'F8' }};...
%           {'Label', 'N2', 'Window', [ 150 360 ], 'Polarity', 'Negative', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', { 'FT7', 'FC5', 'FC3', 'FC1', 'FCZ', 'FC2', 'FC4', 'FC6', 'FT8' }};...
%           {'Label', 'N2', 'Window', [ 150 360 ], 'Polarity', 'Negative', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', { 'T7', 'C5', 'C3', 'C1', 'CZ', 'C2', 'C4', 'C6', 'T8' }};...
%           {'Label', 'N2', 'Window', [ 230 400 ], 'Polarity', 'Negative', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', { 'TP7', 'CP5', 'CP3', 'CP1', 'CPZ', 'CP2', 'CP4', 'CP6', 'TP8', 'CPPZ' }};...
%           {'Label', 'N2', 'Window', [ 230 400 ], 'Polarity', 'Negative', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', { 'P7', 'P5', 'P3', 'P1', 'PZ', 'P2', 'P4', 'P6', 'P8' }};...
%           {'Label', 'N2', 'Window', [ 230 400 ], 'Polarity', 'Negative', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', { 'PO7', 'PO5', 'PO3', 'POZ', 'PO4', 'PO6', 'PO8' }};...
%           {'Label', 'N2', 'Window', [ 230 400 ], 'Polarity', 'Negative', 'Interval', [ -25 25 ], 'Neighborhood', 9, 'Channels', { 'O1', 'OZ', 'O2' }}...
%           });
%
%   Note: Because of the output, it is possible to merge peaks. The example below shows how to combine
%   the N2 and P3 peaks into one for ease of outputting. The labels differentiate the peaks within the structure.
%
%       N2peaks = erppeakinterval(ERP, 'Window', [ 150 300 ], 'Polarity', 'Negative', 'Neighborhood', 9, 'Channels', 1:ERP.nchan, 'Interval', [ -25 25 ], 'Label', 'N2');
%       P3peaks = erppeakinterval(ERP, 'Window', [ 300 600 ], 'Polarity', 'Positive', 'Neighborhood', 9, 'Channels', 1:ERP.nchan, 'Interval', [ -25 25 ], 'Label', 'P3');
%       ERP.peaks = [N2peaks, P3peaks];
%
%   
%   % Example method to extract data from the structure for a subset of  channels
%   desiredarray = { 'FZ', 'CZ', 'PZ' };
%   mastermatrix = NaN(10,numel(desiredarray));
%   for participants = 1:10
%       outputmatrix = NaN(1,numel(desiredarray));
%       for cC = 1:numel(desiredarray)
%           outputmatrix(1,cC) = ERP.peaks.P3(find(strcmpi({ERP.peaks.P3.channel},desiredarray(cC)))).amplitude;
%       end
%       mastermatrix(participants,:) = outputmatrix;
%   end
%
%   Author: Matthew B. Pontifex, Health Behaviors and Cognition Laboratory, Michigan State University, March 8, 2015
%   revised for multipeaks - 3-25-2015 - mp

    try, size(varargin{:},1); r.opt = 2; catch, r.opt = 1; end % Pass it must be a multi entry; Catch it must be a standard entry
   
    if (r.opt == 1)
        if ~isempty(varargin)
            r=struct(varargin{:});
        end
        if (size(r,2)>1) % Only occurs when a cell array is included for the channels
            r=struct(varargin{1:(end-2)}); % Force the structure to skip it
            % Find the channel indices for each channel label
            chanlabs = varargin{end};
            channelsCurrent = [];
            for rC=1:numel(chanlabs)
                temp = find(strcmpi({INERP.chanlocs.labels}, chanlabs(rC)));
                if ~isempty(temp)
                    if (numel(temp) > 1)
                        temp = temp(1);
                    end
                    channelsCurrent(end+1) = temp;
                end
            end
            r.Channels = channelsCurrent;
        end
        try, r.Latencies; catch, r.Latencies = 0; end
        try, r.Interval; catch, r.Interval = [ 0 0 ]; end
        try, r.Channels; catch, r.Channels = 1:INERP.nchan; end
        try, r.Window; catch, r.Window = 0; end
        try, r.Polarity; catch, r.Polarity = 'Positive'; end
        try, r.Neighborhood; catch, r.Neighborhood = 9; end
        try, r.Bin; catch, r.Bin = 1; end
        try, r.Label; catch, r.Label = ''; end

        if ((r.Latencies == 0) & (r.Window == 0))
            help erppeakinterval
            error('Error at erppeakinterval(). Either peak latency or window information must be provided.');
        end
        if strcmpi(r.Polarity, 'Positive')
            r.Polarity = 1;
        else
            if strcmpi(r.Polarity, 'Negative')
                r.Polarity = 0;
            else
               r.Polarity = 1; 
            end
        end

        if (r.Latencies == 0)
            % Screen Window relative Epoch size
            if (isempty(find(INERP.times == r.Window(1))) || isempty(find(INERP.times == r.Window(2)))) % Window period falls outside of the available epoch window
                msg = sprintf('Error at erppeakinterval(). Mismatch between the window period and the epoch size. A window period of %d to %d ms was specified but the epoch only contains data from %d to %d ms.', r.Window(1), r.Window(2), INERP.times(1), INERP.times(end));
                error(msg);
            end

            % Screen Window relative to Neighborhood values
            boolerr = 0;
            if ((find(INERP.times == r.Window(1))) - r.Neighborhood < 1) % not enough points on the left of window
                boolerr = 1;
            end
            if ((find(INERP.times == r.Window(2))) + r.Neighborhood > size(INERP.times,2)) % not enough points on the right of window
                boolerr = 1;
            end
            if (boolerr == 1)
                help geterpvalues
                msg = sprintf('Error at erppeakinterval() for geterpvalues(). There are not enough points for the specified neighborhood window outside of the specified window period.');
                error(msg);
            end        

            % Get peak latencies
            r.Latencies = geterpvalues(INERP, r.Window, r.Bin, r.Channels, 'peaklatbl', 'pre', 1, r.Polarity, r.Neighborhood, 1, 0.5, 0, 1);
        end

        % Verify that each channel has latency information.
        if (numel(r.Latencies) ~= numel(r.Channels))
            help erppeakinterval
            error('Error at erppeakinterval(). Peak latency information should be provided for each channel, the number of peaks and latencies do not match. This error may also indicate that ERPLABs geterpvalues() had an error.');
        end

        % Correct interval latency values to use points
        r.Interval(1) = ceil(r.Interval(1)*(INERP.srate/1000));
        r.Interval(2) = floor(r.Interval(2)*(INERP.srate/1000));

        % Convert peak latencies to point values
        r.Points = r.Latencies;
        for rC = 1:numel(r.Latencies)
            if ~(isnan(r.Latencies(rC)))
                r.Points(rC) = find(INERP.times==r.Latencies(rC));
            end
        end

        % Screen latencies relative to window period
        for rC = 1:numel(r.Points)
            if ((r.Points(rC) + r.Interval(1)) < 0) || ((r.Points(rC) + r.Interval(2)) > INERP.pnts)
                help erppeakinterval
                msg = sprintf('Error at erppeakinterval(). The interval period for channel %d falls outside the available points, use a different latency or narrow the interval window.', rC);
                error(msg);
            end
        end

        % Extract mean amplitude values
        pamp = zeros(1,numel(r.Channels));
        perr = zeros(1,numel(r.Channels));
        pmin = zeros(1,numel(r.Channels));
        pmax = zeros(1,numel(r.Channels));
        for rC = 1:numel(r.Channels)
            if ~(isnan(r.Latencies(rC))) % pull mean amplitude if there is a latency point for that channel
                pamp(rC) = mean(INERP.bindata(r.Channels(rC),(r.Points(rC) + r.Interval(1)):(r.Points(rC) + r.Interval(2)),r.Bin));
            else
                pamp(rC) = NaN;
            end
            if (~isnan(r.Latencies(rC)) && (~isempty(INERP.binerror))) % pull mean error if there is a latency point and the error is not empty
                perr(rC) = mean(INERP.binerror(r.Channels(rC),(r.Points(rC) + r.Interval(1)):(r.Points(rC) + r.Interval(2)),r.Bin));
            else
                perr(rC) = NaN;
            end
            if isfield(INERP, 'binmin')
                pmin(rC) = mean(INERP.binmin(r.Channels(rC),(r.Points(rC) + r.Interval(1)):(r.Points(rC) + r.Interval(2)),r.Bin));
            else
                pmin(rC) = NaN;
            end
            if isfield(INERP, 'binmax')
                pmax(rC) = mean(INERP.binmax(r.Channels(rC),(r.Points(rC) + r.Interval(1)):(r.Points(rC) + r.Interval(2)),r.Bin));
            else
                pmax(rC) = NaN;
            end
        end

        % Load values into structure
        outstruct = struct('channel', [], 'channelnumber', [], 'amplitude', [], 'error', [], 'latency', [], 'label', [], 'window', [], 'interval', [], 'polarity', [], 'neighborhood', [], 'bin', [], 'minimum', [], 'maximum', []);
        for rC = 1:numel(r.Channels)
            outstruct(rC).channel = INERP.chanlocs(r.Channels(rC)).labels;
            outstruct(rC).channelnumber = r.Channels(rC);
            outstruct(rC).amplitude = pamp(rC);
            outstruct(rC).error = perr(rC);
            outstruct(rC).latency = r.Latencies(rC);
            outstruct(rC).label = r.Label;
            outstruct(rC).window = r.Window;
            outstruct(rC).interval = r.Interval;
            outstruct(rC).polarity = r.Polarity;
            outstruct(rC).neighborhood = r.Neighborhood;
            outstruct(rC).bin = r.Bin;
            outstruct(rC).minimum = pmin(rC);
            outstruct(rC).maximum = pmax(rC);
        end
    else % Multiple cells were entered
        handles=struct;
        tempvarargin = varargin{:};
        for cS = 1:numel(varargin{:})
            currentvars = tempvarargin{cS};
            handles.(sprintf('r%d',cS)) = erppeakinterval(INERP, currentvars{:});
            
        end
        
        % Collapse similarly labled structures
        for cS = 1:numel(varargin{:})
            if isfield(handles, sprintf('r%d',cS))
                initlab = handles.(sprintf('r%d',cS))(1).label;
                for cS2 = 1:numel(varargin{:})
                    if isfield(handles, sprintf('r%d',cS2))
                        checklab = handles.(sprintf('r%d',cS2))(1).label;
                        if strcmpi(initlab,checklab) % Labels are the same
                            if (cS ~= cS2) % Not using the same inputs
                                handles.(sprintf('r%d',cS)) = [handles.(sprintf('r%d',cS)), handles.(sprintf('r%d',cS2))];
                                handles = rmfield(handles,sprintf('r%d',cS2));
                            end
                        end
                    end
                end
            end
        end
        
        handles2=struct;
        handlescount = 1;
        for cS = 1:numel(varargin{:})
            if isfield(handles, sprintf('r%d',cS))
                handles2.(sprintf('r%d',handlescount)) = handles.(sprintf('r%d',cS));
                handlescount = handlescount + 1;
            end
        end
        handlescount = handlescount - 1;

        % Obtain matrix of channels in structure
        chanlabs = [handles2.(sprintf('r%d',1))(:).channelnumber];
        if (handlescount > 1)
            for cS = 2:handlescount
                chanlabs =  intersect(chanlabs, [handles2.(sprintf('r%d',cS))(:).channelnumber]);
            end
        end

        % Check if later components occur before earlier components
        % (assumes early component is correct)
        for cS = 2:handlescount
            issuelist = NaN(1,numel(chanlabs));
            issueminlat = NaN(1,numel(chanlabs));
            for cC = 1:numel(chanlabs)
                % For each channel check that the latency for the second
                % component does not occur before the latency of the first
                % component
                temp1 = find([handles2.(sprintf('r%d',cS-1))(:).channelnumber]==chanlabs(cC));
                temp2 = find([handles2.(sprintf('r%d',cS))(:).channelnumber]==chanlabs(cC));
                if (handles2.(sprintf('r%d',cS))(temp2).latency < handles2.(sprintf('r%d',cS-1))(temp1).latency)
                    issuelist(cC) = temp2;
                    issueminlat(cC) = handles2.(sprintf('r%d',cS-1))(temp1).latency;
                end
            end
            for cC = 1:numel(chanlabs)
                if ~isnan(issuelist(cC))
                    % Obtain original call information
                    cChanI = handles2.(sprintf('r%d',cS))(issuelist(cC)).channelnumber;
                    cWin = handles2.(sprintf('r%d',cS))(issuelist(cC)).window;
                    cBin = handles2.(sprintf('r%d',cS))(issuelist(cC)).bin;
                    cPol = handles2.(sprintf('r%d',cS))(issuelist(cC)).polarity;
                    cNei = handles2.(sprintf('r%d',cS))(issuelist(cC)).neighborhood;
                    cInt = handles2.(sprintf('r%d',cS))(issuelist(cC)).interval;

                    % revise window period
                    if (cWin(2) > issueminlat(cC))
                        cWin(1) = issueminlat(cC);
                        handles2.(sprintf('r%d',cS))(issuelist(cC)).window = cWin;
                        handles2.(sprintf('r%d',cS))(issuelist(cC)).latency = geterpvalues(INERP, cWin, cBin, cChanI, 'peaklatbl', 'pre', 1, cPol, cNei, 1, 0.5, 0, 1);

                        Point = find(INERP.times==handles2.(sprintf('r%d',cS))(issuelist(cC)).latency);
                        if ~(isnan(Point)) % pull mean amplitude if there is a latency point for that channel
                            handles2.(sprintf('r%d',cS))(issuelist(cC)).amplitude = mean(INERP.bindata(cChanI,(Point + cInt(1)):(Point + cInt(2)),cBin));
                        else
                            handles2.(sprintf('r%d',cS))(issuelist(cC)).amplitude = NaN;
                        end
                        if (~isnan(Point) && (~isempty(INERP.binerror))) % pull mean error if there is a latency point and the error is not empty
                            handles2.(sprintf('r%d',cS))(issuelist(cC)).error = mean(INERP.binerror(cChanI,(Point + cInt(1)):(Point + cInt(2)),cBin));
                        else
                            handles2.(sprintf('r%d',cS))(issuelist(cC)).error = NaN;
                        end                        
                    end

                end
            end
        end

        % Output structure
        outstruct = struct;
        for cS = 1:handlescount
            outstruct.(sprintf('%s',handles2.(sprintf('r%d',cS))(1).label)) = handles2.(sprintf('r%d',cS));
        end
    end
    
end

