%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Scope:      nLight (Numerical LIbrary for enGineering High Tech) Framework 0.1 
%%% Author:     marco.buzio@cern.ch
%%% Created:    18.01.2014
%%% Last Rev:   
%%% Class:      Sprint = Scattered Points Rapid INterpolator
%%% Notes:      defines an (optionally) oriented series of points
%%% 
%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef Sprint < handle % inheritance form handle is needed for the constructor to work 
    
    properties
        X                 = [];       % column vectors of original data points
        Y                 = [];       % column vectors of original data points
        dYdX              = [];       % slopes at each interval (pre-computed)
        Domain            = [];
        Branch            = [];       % sequential index used for multi-valued functions
        BranchStart       = [];     
        lastIndex         = [];       % start searching the interval close to the last used one (TODO save sorted X + binary search)
        InterpolationMode = [];  
        Type              = [];
    end
    
    methods
        
        % ----------------------------------------------------------------------------------------------------------------------- 
        % -- constructor 
        % ----------------------------------------------------------------------------------------------------------------------- 

        % type                = 'single-valued' (all points sorted by x) or 'multi-vauled' (the order in which they are given is presented)
        % interpolation_mode  = 'linear', 'spline' .....   (NB only linear for now)
        % merge               = boolean (in single-valued mode -> merge values at same x in the same Add() operation, otherwise generate an error)
        function s=Sprint(x,y,type,interpolation_mode,merge)

          if nargin<3, type                 = 'single-valued'; end
          if nargin<4, interpolation_mode   = 'linear';        end
          if nargin<5, merge                = false;           end

          s.InterpolationMode = interpolation_mode;

          % otherwise, error('nLight::Sprint::Interpolate(): Undefined inter');


          s.Type              = type;

          if nargin>0
            if isempty(x), x=[1:length(y)]; end
            s.Add(x,y,merge);
          end % if nargin>0     
        end % constructor

        % ----------------------------------------------------------------------------------------------------------------------- 
        % -- initialization/update function 
        % ----------------------------------------------------------------------------------------------------------------------- 

        % init empty, add one or more points at a time
        % x and y must be vectors of same length
        % two basic modes:  single_valued = true  ->  X values are sorted immediately, duplicates are merged or optionally generate an error
        %                   single_valued = false ->  X values are stored in the order in which they are given
        function ok=Add(this,x,y,merge)

            if nargin<4, merge=false; end
        
            if ~isrealvector(x),    error('Sprint::Add(): x must be a real-valued numeric vector'); end;    x=makecolumn(x);
            if ~isrealvector(y),    error('Sprint::Add(): y must be a real-valued numeric vector'); end;    y=makecolumn(y);
            n = length(x);
            if n~=length(y),        error('Sprint::Add(): the length of x (%d) and of y (%d) must match',n,length(y)); end;  
            
            
            
            if this.IsSingleValued() %---- look for duplicates (in the sorted array, for speed) ------------------
            
                sorted_points=sortrows([x y; this.X this.Y]); % add to existing points and sort by x
                nsp = size(sorted_points,1);
                
                i_to_keep=[1:nsp];  % index of datapoints to keep after the optional merging
                for i=1:nsp
                    i_duplicated=[];
                    for k=i+1:nsp 
                        if      sorted_points(k,1)==sorted_points(i,1),     i_duplicated(end+1)=k;  
                        elseif  sorted_points(k,1)> sorted_points(i,1),     break;
                        end    
                    end % for k
                    if ~isempty(i_duplicated)
                        if merge,   
                                    sorted_points(i,2)=mean(sorted_points([i,i_duplicated],2));
                                    sorted_points(i_duplicated,2)=NaN; % the entire will be to be left out later
                                    i_to_keep(i_duplicated) = 0;
                        else        error('Sprint::Add():  duplicated x value = %f (sorted index=%d) is not allowed in single-valued mode',sorted_points(i,1),i);
                        end
                    end
                end % for i
               
                % copy row by row, leaving out rows with y=NaN
                i_to_keep = (i_to_keep>0);
                this.X=sorted_points(i_to_keep,1);
                this.Y=sorted_points(i_to_keep,2);

            else %------ simply append the given points  to the existing arrays ------------------------
                
                this.X=[this.X; x];
                this.Y=[this.Y; y];

                % TODO incremental Domain update here ?
                
            end

            ok=this.Setup();
        end
        
     
        % take as input a series of segments defined in terms of slope and duration (same length)
        function ok=AddVectors(this,dydx,dx,merge)

            if nargin<4, merge=false; end
        
            if ~isrealvector(dydx), error('Sprint::AddVectors(): dydx must be a real-valued numeric vector'); end;    dydx = makecolumn(dydx);
            if ~isrealvector(dx),   error('Sprint::AddVectors():   dx must be a real-valued numeric vector'); end;    dx   = makecolumn(dx);
            n = length(dydx);
            if n~=length(dx),       error('Sprint::AddVectors(): the length of dydx (%d) and of dx (%d) must match',n,length(dx)); end;  

            % set initial point by default to (0,0), otherwise take the last in the list
            if this.N()>0,  x0=this.X(end); y0=this.Y(end); 
            else            x0=0;           y0=0; 
            end

            x=zeros(n,1); 
            y=zeros(n,1);
            for i=1:n
                x(i)=x0+dx(i);          x0=x(i);
                y(i)=y0+dydx(i)*dx(i);  y0=y(i);
            end % for i
            
            ok=this.Add(x,y,merge);

        end % function AddVectors()

        % complete the initialization
        % must be called after each addition
        function ok=Setup(this)

            if this.N()==0, error('Sprint::Setup(): No data points'); end

            diff_x = diff(this.X);
            diff_y = diff(this.Y);
            this.dYdX=diff_y./diff_x; % this returns correctly Inf when X does not change
            
            this.Branch=zeros(this.N(),1);   % in any case
            
            if this.N()==1,  this.Branch(1)=1; this.BranchStart(1)=1; ok=true; return; end % in this simple case, that's the end of the story

% TODO replace all this with data structures/functions shared with mFC           

            % look ahead to find the sign of the first branch: look for the first dx~=0
            for i=1:this.N()-1, if diff_x(i)~=0, current_direction=sign(diff_x(i)); break; end;  end
            this.Branch(1)     =current_direction; % +- 1 by definition
            this.BranchStart(1)=1;    % TODO this does not work if the first segment is vertical

            % scan through the points to assign branch indices
            % DEF:  a point is judged by the slope preceding
            for i=2:this.N()
                new_direction = sign(diff_x(i-1));
                if (new_direction==0 || new_direction==current_direction), % same branch as before
                    this.Branch(i)=this.Branch(i-1);
                else % new branch detected !
                    new_branch_index=abs(this.Branch(i-1))+1;
                    this.Branch(i)=new_direction*(new_branch_index);
                    this.BranchStart(new_branch_index)=i; % this automatically extends BranchStart[]
                    current_direction = new_direction;
                end 
            end % for i 

            this.Domain = [min(this.X), max(this.X)];    
            ok=true;

        end % function setup 


        % ----------------------------------------------------------------------------------------------------------------------- 
        % -- bookkeeping 
        % ----------------------------------------------------------------------------------------------------------------------- 
        
        function npoints=N(this)
            npoints=size(this.X,1);
        end

        function SetMode(this,newmode)
            this.Mode=newmode;
        end

        function sv=IsSingleValued(this)
            sv = ~isempty(strfind(lower(this.Type),'single'));
        end

        function [ymin ymax]=Range(this) % TODO check ???
            ymin=min(this.Y); 
            ymax=max(this.Y);
        end

        function dx = Interval(this)
            dx = this.Domain(end) - this.Domain(1);
        end

        function ok=IsOk(this)
            ok = this.N()>=1 && size(this.Y,1)==this.N() && size(this.dYdX,1)==this.N()-1;
        end

        function nb=NB(this)
            nb=length(this.BranchStart);
        end

        % get  X(index)<=x<X(index+1) 
        % TODO speed up with binary search
        % NB this is called only iof at least an interval exists, is if N()>=2
        function indices=GetInterval(this,x)

            indices=[];

            
            if      x<this.Domain(1)     % --------- left extrapolation ---------------------------
                if this.X(2)>this.X(1),    indices=1; 
                else  error('Sprint::GetInterval - no left extrapolation interval found for x=%f',x); 
                end
            elseif  x>this.Domain(2)     % --------- right extrapolation ---------------------------
                if this.X(end)>this.X(end-1),  indices=this.N()-1; 
                else  error('Sprint::GetInterval - no right extrapolation interval found for x=%f',x); 
                end
            else                    % --------- conventional interpolation ------------------------
                for b=1:this.NB()
                    for i=this.BranchStart(b):this.N()-1
                        xbound=sort([this.X(i), this.X(i+1)]); % why abs ??
                        if xbound(1)<=x && x<=xbound(2), 
                            indices(end+1)=i; break; 
                        end
                    end % for i
                end % for b
            end % if
            
        end

        % ----------------------------------------------------------------------------------------------------------------------- 
        % -- interpolation
        % ----------------------------------------------------------------------------------------------------------------------- 
        
        % x can be a scalar or a vector
        % TODO: implement extrapolation on multi-valued functions ...
        % TODO: restrict interpolation to a given branch ? include branch indexing
        function y=Interpolate(this,x)
            %profile on;
            if ~this.IsOk(), error('Sprint::interp(): object not initialized'); end % TODO take away to speed up
            if ~isrealvector(x), error('Sprint::interp(): argument must be a real vector'); end
            y=zeros(length(x),1);
            n=this.N();  
            
            % trivial case
            if n==1, y=this.Y(1); return; end 

            switch this.InterpolationMode
                case 'linear'

                    for k=1:length(x) % cycle over input vector

                        i_found=this.GetInterval(x(k));   % i_found=start index if the interpolation interval
                        if isempty(i_found), 
                            error('nLight::Sprint::Interpolate(): no valid interpolation interval found @ x=%f',x(k)); 
                        end

                        if this.dYdX(i_found)~=inf,
                            y(k)=this.Y(i_found)+(x(k)-this.X(i_found))*this.dYdX(i_found);   
                        else
                            y(k)=mean([this.Y(i_found), this.Y(i_found+1)]); % TODO deal with several Inf in a row, which are lost here ...
                        end
                        this.lastIndex=i_found; % TODO use to speed up search

                    end % for k
                %case 'spline' % TODO
            end
            %profile off
        end % function interp

        % TODO merge with above (FTB, linear interpolation only)
        function y=InterpolateSequential(this,xstart,xstop,n)

            % trivial case
            if this.N()==1, y=this.Y(1)*ones(n,1); return; end 

            y  = zeros(n,1);

            x  = xstart;
            dx = (xstop-xstart)/(n-1);
            i = this.GetInterval(x);        % interval index
            j = 1;                          % data point index in the output vector
            while j<=n
                
                if i<this.N()-1,  ni = floor((this.X(i+1)-x)/dx+1) ;  % points inside the current interval
                else              ni = n-j+1;
                end    
                
                xi = x + dx*[0:ni-1];
                y(j:j+ni-1) = this.Y(i)+(xi-this.X(i))*this.dYdX(i); 

                                  j = j + ni;
                if i<this.N()-1,  i = i + 1; end % otherwise we are already at the last interval
                                  x = x + ni*dx;
            end
            
        end
        
        
        % TODO implement a true Simpson
        function int=Integral(this,xmin,xmax,tol)
            int=0;
            N=40;
            dx=(xmax-xmin)/N;
            x=xmin+dx/2;
            for i=1:N
                int=int+this.Interpolate(x);
                x=x+dx;
            end
            int=int*dx;
        end


        % 
   %     function der=Derivative(this,x,order)
   %        if nargin<3, order=1; end
   %        dx=this.Domain()/1000;
   %        der=(this.interp(x+dx/2)-this.interp(x-dx/2))/dx;    
   %        % TODO implement higher order
   %     end
        

        % overload .(){} ACCESSOR operators (WARNING: by matlab design, this function will not work inside own's class methods)
        % NB: ts can be a list of operator/subscript pairs eg. obj.subobj1.subobj2(index)
        % syntax:   ts=string  -> call GetCoil
%        function varargout=subsref(obj,ts) % ts={type,fields}
%            for index=1:length(ts) % handle multi-level subsref
  %              switch ts(index).type
  %                  case '()'      
  %                      if isscalar(obj) % the overload concerns only calls made by a single object 
 %                           x=ts.subs{1};
 %                           if isfloat(x),  varargout{1}=obj.interp(x);  return; % a coil object
  %                          else            error('IrregularInterpolator::subsref() invalid argument type');
  %                          end % if 
  %                      end
    %                case '{}' 
    %                    [varargout{1:nargout}] = builtin('subsref',obj,s);                
    %                case '.'  % must be redefined
    %                    [varargout{1:nargout}] = builtin('subsref',obj,s);                
    %                otherwise
    %                   error('IrregularInterpolator::subsref() invalid argument type');
   %             end % switch
   %         end % for index
            % otherwise
  %          [varargout{1:nargout}] = builtin('subsref',obj,ts);                
 %       end 
% !!!! too complicated. This gets called for all functions, whenever . or () or {} syntax are involved

        % ----------------------------------------------------------------------------------------------------------------------- 
        % -- I/O
        % ----------------------------------------------------------------------------------------------------------------------- 

        function Plot(this)

            xyplot([this.X, this.X],...
                   [this.Y, this.Y],'Sprint Diagnostics','X','Y',{},{'or','-c'});

        end % function Plot()


    end % methods block
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Benchmarks 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   s = Sprint([1 1 3],[1 2 3],'single-valued','linear',MERGE.OFF); s.Plot();
%
%
%   s = Sprint([1 2 3 2 1],[1 2 3 4 5],'single-valued','linear',MERGE.OFF); s.Plot();
