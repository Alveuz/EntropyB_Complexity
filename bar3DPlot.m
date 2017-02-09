function pp = bar3DPlot(M, width, param1Labels, varargin)
    % bar3DPlot  3D bar graph to graphic ESC measures.
    %
    % M             - a N x M matrix.
    % width         - bar width (1 means no separation between bars),
    %                 this feature must be 0 <= width <= 1.
    % param1Labels  - a N x 1 string vector, each element corresponds to
    %                 variables in the dataset.
    % varargin{1}   - a M x 1 string vector, it contains the strings of a 
    %                 second parameter of the experiment.
    %
    % See also: bar3, hist3

    %If width is not provided it is a default value
    if nargin < 2, width = 0.8; end
    assert(ismatrix(M), 'Matrix expected.')
    
    %Or if the width is beyond the permitted value it is fixed within it.
    if(width <=0)
      width = 0.1;
    elseif(width >1)
      width = 1;      
    end
    
    %If the parameters label vector is missing, we assumed that
    %ESC results will be plotted.
    if (isempty(varargin))
      param2Labels = char('Emergence','Self-Organization','Complexity');
    else
      param2Labels=varargin{1};
    end

    % size of matrix
    [ny,nx] = size(M);

    % first we build a "template" column-bar (8 vertices and 6 faces)
    % (bar is initially centered at position (1,1) with width=? and height=1)
    hw = width / 2;    % half width
    [X,Y,Z] = ndgrid([1-hw 1+hw], [1-hw 1+hw], [0 1]);
    v = [X(:) Y(:) Z(:)];
    f = [
        1 2 4 3 ; % bottom
        5 6 8 7 ; % top
        1 2 6 5 ; % front
        3 4 8 7 ; % back
        1 5 7 3 ; % left
        2 6 8 4   % right
    ];

    % replicate vertices of "template" to form nx*ny bars
    [offsetX,offsetY] = meshgrid(0:nx-1,0:ny-1);
    offset = [offsetX(:) offsetY(:)]; offset(:,3) = 0;
    v = bsxfun(@plus, v, permute(offset,[3 2 1]));
    v = reshape(permute(v,[2 1 3]), 3,[]).';

    % adjust bar heights to be equal to matrix values
    v(:,3) = v(:,3) .* kron(M(:), ones(8,1));

    % replicate faces of "template" to form nx*ny bars
    increments = 0:8:8*(nx*ny-1);
    f = bsxfun(@plus, f, permute(increments,[1 3 2]));
    f = reshape(permute(f,[2 1 3]), 4,[]).';

    %% plot
    % prepare plot
    if exist('OCTAVE_VERSION','builtin') > 0
        % If running Octave, select OpenGL backend, gnuplot wont work
        graphics_toolkit('fltk');
        hax = gca;
    else
        hax = newplot();
        set(ancestor(hax,'figure'), 'Renderer','opengl')
    end
  
    % draw patch specified by faces/vertices
    % (we use a solid color for all faces)
    p = patch('Faces',f, 'Vertices',v, ...
        'FaceColor',[0.75 0.85 0.95], 'EdgeColor','k', 'Parent',hax);
    view(hax,3); grid(hax,'on');
    set(hax, 'XTick',1:nx, ...
             'YTick',1:ny, ...
             'Box','off', 'YDir','reverse', ...
        'PlotBoxAspectRatio',[1 1 (sqrt(5)-1)/2]) % 1/GR (GR: golden ratio)

    set(0, 'defaultaxesfontname', 'Arial') 
    set(gca,'xticklabel',param2Labels);  
    set(gca,'yticklabel',param1Labels);    
        
    v = get(p, 'Vertices');
    fvcd = v(:,3);
    fvcd = fvcd * -1;
    
    fvcd1     = zeros(size(fvcd,1),1);
    stepSize  = 8;
    for i=1:(size(fvcd,1)/8);
      if(i==1)
        fvcd1(i:(i*stepSize),1) = repmat(fvcd(stepSize,1),8,1);
      else
        a = (i-1)*stepSize;
        b = i*stepSize;
        fvcd1(a+1:b,1) = repmat(fvcd(b,1),8,1);
      end;
      
    end;
    
    set(p, 'FaceVertexCData',fvcd1, 'FaceColor','flat')
    axis tight;
    %daspect([1 1 10]); 
    set(p, 'EdgeColor','k')
    
    if nargout > 0
        pp = p;
    end
end