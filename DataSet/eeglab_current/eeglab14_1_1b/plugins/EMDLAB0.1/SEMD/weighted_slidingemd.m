%weighted_slidingemd() - Perform weighted Sliding Empirical Mode Decomposition (wSEMD) 
%            on the input data.%
% INPUT:
%
% data        = input data which is supposed to be decomposed
% windowsize  = sample size of the single windows, with are supposed to be decomposed with plain EMD (e.g. 2000); should be a multiple of %
%              the step size (default -> 100)
% stepsize    = sample size of the step size between the single windows (default -> 20)
% ntrials      = Number of trials  (default -> 1)

%
% OUTPUT:
% allmodes : A matrix of the IMFs.
%
%
% The code is written by Angela Zeiler (angela.zeiler@biologie.uni-regensburg.de) and modified by
%  Karema Al-Subari (Karema.Al-Subari@ur.de) and Saad Al-Baddai (Saad.Al-Baddai@ur.de).


function allmodes= weighted_slidingemd(dat,varargin)

allmodes=[];


if nargin < 1
  help weighted_slidingemd 
  return
end

%%%%%


[Nchans Nframes] = size(dat); % determine the data size

%%%%%%%%%%%%%%%%%%%%%% Declare defaults used below %%%%%%%%%%%%%%%%%%%%%%%%
%

DEFAULT_windowsize        = 100;  % Default Window Size
DEFAULT_stepsize          = 20;  % Default Step Size
DEFAULT_ntrials           = 1;  % Default Number of Trials

%%%%%%%%%%%%%%%%%%%%%%% Set up keyword default values %%%%%%%%%%%%%%%%%%%%%%%%%

windowsize                 = DEFAULT_windowsize;
stepsize                   = DEFAULT_stepsize;
ntrials                    = DEFAULT_ntrials;


%%%%%%%%%% Collect keywords and values from argument list %%%%%%%%%%%%%%%

for i = 1:2:length(varargin) % for each Keyword
      Keyword = varargin{i};
      Value = varargin{i+1};
  if ~isstr(Keyword)
         fprintf('weighted_slidingemd(): keywords must be strings')
         return
  end
 Keyword = lower(Keyword); % convert upper or mixed case to lower

      if strcmp(Keyword,'windowsize') | strcmp(Keyword,'Windowsize')
         if isstr(Value)
            fprintf('weighted_slidingemd():windowsize must be integer number')
            return
        elseif ~isempty(Value)
           windowsize = Value;
           if ~windowsize,
            windowsize = DEFAULT_windowsize;
            end
         end
      elseif strcmp(Keyword,'stepsize') | strcmp(Keyword,'Stepsize')
         if isstr(Value)
            fprintf('weighted_slidingemd(): stepsize must be integer number')
            return
        elseif ~isempty(Value)
         stepsize = Value;
          if ~stepsize,
            stepsize = DEFAULT_stepsize;
          end
         end
      elseif strcmp(Keyword,'ntrials')| strcmp(Keyword,'Ntrials')
         if isstr(Value)
            fprintf('weighted_slidingemd(): modes number must be  integer')
            return
        elseif ~isempty(Value)
         ntrials = Value;
          if ~ntrials,
            ntrials = DEFAULT_ntrials;
          end
         end
      
        
     end
end
%%%%
if ntrials>1
     error('Error: SEMD works only in case there is only one epoche!');
    return;
end
if size(dat,1)<windowsize
     error('Error: data length must be larger than window size!');
    return;
end
disp('running...............................................................................................................................................');
for nchans=1:size(dat,2)
 
 data=dat(:,nchans);
 allmodes(nchans,1,:)=data;
 laenge=length(data);

overlap=1-(stepsize/windowsize);
if (mod(windowsize,stepsize)~=0) 
     error('Error: window size must be a multiple of the step size!'); 
     return;
end
ensemble=round(windowsize/stepsize);

residuum=fix(log2(windowsize))+1; % residuum is the last component of decomposition
rest=round(overlap*windowsize);

weight=wgauss(windowsize,stepsize);

if(mod(laenge,windowsize)==0) 
    columnnumberwithoutoverlap=round(laenge/windowsize);
    columnnumber=(((columnnumberwithoutoverlap-1)*ensemble)+1); % calculate the required window number
end
if(mod(laenge,windowsize)~=0)
    columnnumberwithoutoverlap=fix(laenge/windowsize); 
    columnnumber=(((columnnumberwithoutoverlap-1)*ensemble)+1); % calculate the required window number
end


matrix_emd=zeros(windowsize,residuum);
matrix=zeros(laenge,residuum-1);


for k=1:columnnumber
    input=data((((k-1)*windowsize)+1-((k-1)*rest)):((k*windowsize)-((k-1)*rest)),1);
 	matrix_emd=emd(input,0,1); % decomposition by EMD 
	
	for imf=2:residuum
		matrix_emd(:,imf)=weight.*matrix_emd(:,imf);
		matrix((((k-1)*windowsize)+1-((k-1)*rest)):((k*windowsize)-((k-1)*rest)),imf-1)=matrix((((k-1)*windowsize)+1-((k-1)*rest)):((k*windowsize)-((k-1)*rest)),imf-1)+matrix_emd(:,imf);
	end
end    

%matrix=matrix(windowsize+1:end-windowsize,:);
allmodes(nchans,2:imf,:)=matrix';
end



   
