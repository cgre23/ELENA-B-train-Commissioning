function [filelist, writedate, maxfilenamelen]=getFileList(testfolder,filetag,fileextension,recurse)

    if nargin<4, recurse=RECURSE.OFF; end

    %------- read in all measurements in the given folder having the given tag, scan metadata from folder file list
    filelist=findtaggedfile(testfolder,filetag,fileextension,'multi',recurse);
    
    % check file modified dates
    n=length(filelist);     if n<1, error('nLight::getFileList(): no files found with tag=<%s> and extension=<%> in folder=<%s>',filetag,fileextension,testfolder); end
    filedates=zeros(n,1);

    maxfilenamelen = 0;    
    for j=1:n
        ft=GetFileTime(filelist{j});
        filedates(j)=datenum(ft.Creation);
        filenamelen = length(getFileNameX(filelist{j}));
        if filenamelen > maxfilenamelen, 
            maxfilenamelen=filenamelen; 
        end
    end % for j
    
    span=max(filedates)-min(filedates);
    
    % writedate->testdate assumes the test was not interrupted by a calibration in the middle !
    % NB: in MMP systems, the file writedate does NOT coincide with the test date (in this case, this is taken from metadata)  
    % used uiwait(messagebox()) to create a modal message
    writedate=datestr(min(filedates)); 
    msg('%d file(s) found in folder: "%s" with tag="%s" and extension="%s" \nFile modification time span=%.2f hours\n',n,testfolder,filetag,fileextension,24*span);
    
    writedate = 0;
    
end % function GetFileSet

