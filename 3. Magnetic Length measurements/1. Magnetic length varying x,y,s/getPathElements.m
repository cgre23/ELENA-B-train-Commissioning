% split a file path in folder, filename and extension
% works also for cell array of paths
% NB does not work on paths:
% TODO: reimplement with out=regexp('C:\CERN\» Collaborations\ITER\TF Coil MM\CCL MM - Tests\2015.04 - La Spezia/--- meas ---\','[\\/]','split')
function [folder, filename, extension, filename_ext] = getPathElements(fullpath)


    if ischar(fullpath)  % basic algorithm for a single path

        path=fullpath;

        folder   ='';
        filename ='';
        extension='';


        % look for the extension (admit multiple dots, of which only the last one signals the extension)
        for j=length(path):-1:1
            if path(j)=='.', extension=path(j+1:end); path(j:end)=[]; break; end
        end

        % look for the base folder
        for j=length(path):-1:1
            if path(j)=='\' || path(j)=='/',    
                folder=path(1:j); path(1:j)=[]; 
                break; 
            end
        end

%         k = 0;
%         while j-k>=1
%             if path(j-k)=='\' || path(j-1)=='/',    
%                 last_folder=path(j-1-k); 
%                 break; 
%             end
%             k = k + 1;
%         end


        % all that remains is the filename
        if isempty(path), error('nLight::getPathElements(): invalid empty filename found in <%s>',fullpath); end
        filename=path(1:end);

        filename_ext = filename;
        if ~isempty(extension), filename_ext=[filename, '.', extension ]; end

    elseif iscellstr(fullpath) % iterate recursively over the given array of paths

        n = numel(fullpath);
        folder       = cell(size(fullpath));
        filename     = cell(size(fullpath));
        extension    = cell(size(fullpath));
        filename_ext = cell(size(fullpath));

        for i=1:n
            [folder{i}, filename{i}, extension{i}, filename_ext{i}] = getPathElements(fullpath{i});
        end % for i

    else
        
        error('nLight::getPathElements(): argument fullpath must be either a string or a cell arrays of strings');

    end



end

