%------------------------------------------------------------------------------------------------------------------------------------------------
%------ Scope:      nLight (numerical LIbrary enGineering High Tech) Framework 0.1 
%------ Author:     marco.buzio@cern.ch
%------ Created:    01.08.2012
%------ Last Rev:   21.11.2012
%------ Function:   findtaggedfile(foldername,tag,ext,mode)
%  find files in the given folder that contains the given tag
%  arguments:   foldername:     folder where to look for the file
%               tag:            tag=text in the file name to search for (can be empty='' or include '*')
%               ext:            optional extension to restrict the search (dot is added automatically if not provided) (can be empty='' or include '*')
%               mode:           'single' (default): get only the fIrst file, warning if there are more
%                               'multi': return a cell array contaning all the files found
%               recurse:        RECURSE.ON, RECURSE.OFF
%  return:      full path of the file(s) found
%------------------------------------------------------------------------------------------------------------------------------------------------

function filepath  = findtaggedfile(foldername,tag,ext,mode,recurse,errormode)

if nargin<2, tag='';                 end
if nargin<3, ext='';                 end       
if nargin<4, mode='single';          end  
if nargin<5, recurse=RECURSE.OFF;    end
if nargin<6, errormode=MODE.VERBOSE; end

filepath = {}; % return an empty cell upon failure

if foldername(end) ~= '\', foldername=[foldername '\']; end   % add final backslash if needed
 
 search_path=[foldername, '*'];
 %if ~isempty(tag), search_path=[search_path, tag, '*'];  end
 if ~isempty(ext),
     if ext(1) ~='.', ext=['.' ext]; end                            % add initial dot if needed
     search_path=[search_path, ext];
 end
 
 if recurse
        filestruct = struct2cell(subdir(search_path));     filestruct = filestruct';
        filelist   = filestruct(:,1);       % absolute paths
 else
        filelist   = dir(search_path);      % relative paths (filenames only: does not dig into subfolders)
 end
  
 nfound=length(filelist);   
 if nfound == 0,
    if errormode>MODE.SILENT,
        warning('No files whatsoever in folder %s',foldername); 
    end
    return;
 end        

 % different treatment, since the two dir functions return different formats
 if  recurse
     pathlist      = filelist;
 else
     pathlist      = cell(nfound,1);
     for i=1:nfound, pathlist(i)={[foldername filelist(i).name]}; end
 end

 % new behavior (sep17): filter out according to multiple tags, using RX
 if ~isempty(tag)
    if ischar(tag), tag={tag}; end % work only with cell array of chars
    kill=[];
    for i=1:nfound
        filename = getFileName(pathlist(i));
        for t=1:length(tag)
            if isnan(pick(RX(filename,tag{t}),1)), 
                kill(end+1)=i; break;
            end
        end
    end
    if ~isempty(kill),
        pathlist(kill(:)) = [];
        nfound = length(pathlist);
    end
 end

 if nfound == 0,
    if errormode>MODE.SILENT, 
        warning('No files in folder %s contaning tag <%s> with extension <%s>',foldername,cell2char(tag),ext); 
    end
    return;
 end        


 % return type is string or cell array of strings, according to mode 
 switch mode
    case 'single',      if nfound>1, warning('More than one files in folder %s contaning tag %s',foldername,cell2char(tag)); end
                        filepath=pathlist{1}; % NB: curly braces needed to get the cell contents
    case 'multi',       filepath=pathlist;
                        sort(filepath);
    otherwise,          error('nLight::findtaggedfile() - invalid mode %s (expected: `single` or `multi`)',mode);
 end   

 

end

