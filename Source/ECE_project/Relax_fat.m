function Relax_fat()

gui = struct();

gui.window = figure('Name', 'Relax!', 'Menubar', 'none', 'Toolbar', 'none', 'NumberTitle',...
    'off', 'Position', [0 400 1000 550]);

menuFile = uimenu(gui.window, 'Label', 'File');
menuFileOpen = uimenu(menuFile, 'Label', 'Open...', 'Callback', @fcnOpen);
menuFileOpenInto = uimenu(menuFile, 'Label', 'Open Into');
menuFileOpen1 = uimenu(menuFileOpenInto, 'Label', 'Panel 1', 'Callback', @fcnOpen);
menuFileOpen2 = uimenu(menuFileOpenInto, 'Label', 'Panel 2', 'Callback', @fcnOpen);
menuFileOpen3 = uimenu(menuFileOpenInto, 'Label', 'Panel 3', 'Callback', @fcnOpen);
menuFileOpen4 = uimenu(menuFileOpenInto, 'Label', 'Panel 4', 'Callback', @fcnOpen);
menuFileClose = uimenu(menuFile, 'Label', 'Close');
menuFileClose1 = uimenu(menuFileClose, 'Label', 'Panel 1', 'Callback', @fcnClose);
menuFileClose2 = uimenu(menuFileClose, 'Label', 'Panel 2', 'Callback', @fcnClose);
menuFileClose3 = uimenu(menuFileClose, 'Label', 'Panel 3', 'Callback', @fcnClose);
menuFileClose4 = uimenu(menuFileClose, 'Label', 'Panel 4', 'Callback', @fcnClose);
menuFileCloseAll = uimenu(menuFile, 'Label', 'Clear All', 'Callback', @fcnClose);
menuFileQuit = uimenu(menuFile, 'Label', 'Quit', 'Callback', @fcnQuit);

menuFit = uimenu(gui.window, 'Label', 'Fit');
menuFitAvg = uimenu(menuFit, 'Label', 'Average');
menuFitAvg1 = uimenu(menuFitAvg, 'Label', 'Single Pixel', 'Callback', @fcnFitAvg,...
    'Checked','on');
menuFitAvg2 = uimenu(menuFitAvg, 'Label', '3x3 Square', 'Callback', @fcnFitAvg);
menuFitAvg3 = uimenu(menuFitAvg, 'Label', '5x5 Square', 'Callback', @fcnFitAvg);
menuFitAvg4 = uimenu(menuFitAvg, 'Label', '11x11 Square', 'Callback', @fcnFitAvg);

menuImage = uimenu(gui.window, 'Label', 'Image');
menuImageColor = uimenu(menuImage, 'Label', 'Colormap');
menuImageColorGray = uimenu(menuImageColor, 'Label', 'Grayscale', 'Callback', @fcnColorGray,...
    'Checked','on');
menuImageColorDef = uimenu(menuImageColor, 'Label', 'Color', 'Callback', @fcnColorGray);
menuImageClear = uimenu(menuImage, 'Label', 'Clear Crosshairs','Callback',@fcnClearCH);
menuImageSave = uimenu(menuImage, 'Label', 'Save Image', 'Callback', @fcnSaveImg);

menuPlot = uimenu(gui.window, 'Label', 'Plot');
menuPlotMode = uimenu(menuPlot, 'Label', 'Mode');
menuPlotMode1 = uimenu(menuPlotMode, 'Label', 'Absolute Value', 'Callback', @fcnPlotMode,...
    'Checked','on');
menuPlotMode2 = uimenu(menuPlotMode, 'Label', 'Real Part', 'Callback', @fcnPlotMode);
menuPlotMode3 = uimenu(menuPlotMode, 'Label', 'Imaginary Part', 'Callback', @fcnPlotMode);
menuPlotMode4 = uimenu(menuPlotMode, 'Label', 'Phase Angle', 'Callback', @fcnPlotMode);
menuPlotSpec  = uimenu(menuPlot, 'Label', 'Display Spectrum');
menuPlotSpec1 = uimenu(menuPlotSpec, 'Label', 'Off', 'Callback', @fcnPlotSpec);
menuPlotSpec2 = uimenu(menuPlotSpec, 'Label', 'On', 'Callback', @fcnPlotSpec, ...
    'Checked','on');
menuPlotSave  = uimenu(menuPlot, 'Label', 'Save Plot...', 'Callback', @fcnPlotSave);

menuMap = uimenu(gui.window, 'Label', 'Map');
menuDoMap = uimenu(menuMap, 'Label', 'Do Rough FF Map','Callback',@fcnRoughFFMap);
%menuDoFMap = uimenu(menuMap, 'Label', 'Do Freq Map','Callback',@fcnFreqMap);
%menuDoDMap = uimenu(menuMap, 'Label', 'Do Diff Map','Callback',@fcnDiffMap);
menuMapBack = uimenu(menuMap, 'Label', 'BG Threshold');
menuMapBack1 = uimenu(menuMapBack, 'Label', '1% max sig', 'Callback', @fcnMapBack,...
    'UserData',1);
menuMapBack2 = uimenu(menuMapBack, 'Label', '5% max sig', 'Callback', @fcnMapBack,...
    'Checked','on','UserData',5);
menuMapBack3 = uimenu(menuMapBack, 'Label', '10% max sig', 'Callback', @fcnMapBack,...
    'UserData',10);
menuMapErr = uimenu(menuMap, 'Label', 'Err Threshold');
menuMapErr1 = uimenu(menuMapErr, 'Label', '+/- 30', 'Callback', @fcnMapErr,...
    'UserData',30);
menuMapErr2 = uimenu(menuMapErr, 'Label', '+/- 50', 'Callback', @fcnMapErr,...
    'Checked','on','UserData',50);
menuMapErr3 = uimenu(menuMapErr, 'Label', '+/- 70', 'Callback', @fcnMapErr,...
    'UserData',70);
%menuMapROI = uimenu(menuMap, 'Label', 'R2* of ROI','Callback',@fcnROI);
%menuMapSave = uimenu(menuMap, 'Label', 'Save Map', 'Callback', @fcnSaveMap);
%menuMapLoad = uimenu(menuMap, 'Label', 'Load Map', 'Callback', @fcnLoadMap);

gui.open  = [menuFileOpen,menuFileOpen1,menuFileOpen2,menuFileOpen3,menuFileOpen4];
gui.close = [menuFileCloseAll,menuFileClose1,menuFileClose2,menuFileClose3,menuFileClose4];
gui.fitavg   = [menuFitAvg1, menuFitAvg2, menuFitAvg3, menuFitAvg4]; 
gui.plotmode = [menuPlotMode1, menuPlotMode2, menuPlotMode3, menuPlotMode4];
gui.plotspec = [menuPlotSpec1, menuPlotSpec2];
gui.mapback  = [menuMapBack1,menuMapBack2,menuMapBack3];
gui.maperr   = [menuMapErr1,menuMapErr2,menuMapErr3];
gui.color = [menuImageColorGray, menuImageColorDef];

%gui.imgdom   = [menuImgDom1, menuImgDom2];

hbox = uiextras.HBox('Parent', gui.window, 'Spacing', 3);

vbox1 = uiextras.VBox('Parent', hbox, 'Spacing', 5);
vbox2 = uiextras.VBox('Parent', hbox, 'Spacing', 5);
set(hbox,'Sizes',[512, -1]);

gui.tabpanel = uiextras.TabPanel('Parent', vbox1, 'Padding', 0);
gui.slider3d = uicontrol('Parent',vbox1, 'Style','slider','Enable','off',...
    'Min',0,'Max',1,'Callback', @fcnSlider3d,'Value',1);
gui.slider4d = uicontrol('Parent',vbox1, 'Style','slider','Enable','off',...
    'Min',0,'Max',1,'Callback', @fcnSlider4d,'Value',1);
set(vbox1,'Sizes',[-1,15,15]);

htab1 = uiextras.VBox('Parent', gui.tabpanel, 'Spacing', 5);
filetext1 = uicontrol('Parent',htab1,'Style','text','String','No file loaded');
imgaxes1 = axes('Parent', htab1, 'ActivePositionProperty', 'Position', 'Color','black');
set(htab1,'Sizes',[15, -1]);

htab2 = uiextras.VBox('Parent', gui.tabpanel, 'Spacing', 5);
filetext2 = uicontrol('Parent',htab2,'Style','text','String','No file loaded');
imgaxes2 = axes('Parent', htab2, 'ActivePositionProperty', 'Position', 'Color','black');
set(htab2,'Sizes',[15, -1]);

htab3 = uiextras.VBox('Parent', gui.tabpanel, 'Spacing', 5);
filetext3 = uicontrol('Parent',htab3,'Style','text','String','No file loaded');
imgaxes3 = axes('Parent', htab3, 'ActivePositionProperty', 'Position', 'Color','black');
set(htab3,'Sizes',[15, -1]);

htab4 = uiextras.VBox('Parent', gui.tabpanel, 'Spacing', 5);
filetext4 = uicontrol('Parent',htab4,'Style','text','String','No file loaded');
imgaxes4 = axes('Parent', htab4, 'ActivePositionProperty', 'Position', 'Color','black');
set(htab4,'Sizes',[15, -1]);

htab5 = uiextras.VBox('Parent', gui.tabpanel, 'Spacing', 5);
filetext5 = uicontrol('Parent',htab5,'Style','text','String','No file loaded');
imgaxes5 = axes('Parent', htab5, 'ActivePositionProperty', 'Position', 'Color','black');
set(htab5,'Sizes',[15, -1]);

gui.imgaxes  = [imgaxes1, imgaxes2, imgaxes3, imgaxes4, imgaxes5];
gui.filetext = [filetext1, filetext2, filetext3, filetext4, filetext5];
gui.mapaxes = imgaxes5;
gui.maptext = filetext5;

gui.plotinfo = uicontrol('Parent',vbox2,'Style','edit','Max',4,'Min',0,...
    'Enable','inactive');
gui.plotaxes = axes('Parent', vbox2);
set(vbox2,'Sizes',[100, -1]);

gui.tabpanel.TabNames = {'Panel 1', 'Panel 2', 'Panel 3', 'Panel 4', 'R2*Map'};
gui.tabpanel.SelectedChild = 1;

plotrange = 0;
plotcolors = {'b','k','r','g'};
plotmode  = 1;  % absolute value
plotsave  = 0;
gridsize = [-1,-1];
coords = [-1,-1];
for num=1:5
  set(gui.imgaxes(num),'UserData',-1);
  set(gui.filetext(num),'UserData',-1);
end
slice = 1;
path = pwd;
avgSize = 0;
map_err_thres = 50;
map_bg_thres = 5;
colormap(gray);
plotspectrum = 1;

function fcnOpen(varargin)
  num = find(gui.open==varargin{1})-1;
  if (num==0)
    % find an open slot to put new file into
    for i=1:4
      if (numel(get(gui.imgaxes(i),'UserData'))==1)
        num = i;
        break;
      end
    end
    if (num==0) % no open slots available
      msgbox(['No panels are available to load a new dataset into.  ',...
              'Please close an existing dataset and try again, ',...
              'or use Open Into to load with a particular panel.']);
      return
    end
  end
  
  [file,path] = uigetfile([path,'/*.*'],'Select a VnmrJ FID file');
    gui.tabpanel.SelectedChild = num;  
    set(gui.filetext(num),'String','Loading...');
    par = readprocpar(path);
    if (~isempty(strfind(par.seqfil,'SE-SPI')))
      fid = OpenTurboSPI(path);
    else
      msgbox('Not a valid SE-SPI file.');
    end
    % Normalize incoming fid
    img = zeros(size(fid));
    for n=1:size(fid,1)
      img(n,:,:,:) = ifftnc(squeeze(fid(n,:,:,:)));
    end
    %img = fid;
    set(gui.imgaxes(num),'UserData',img);
    set(gui.filetext(num),'UserData',par);
    clear fid;
    if size(img,4)>1
      ns = size(img,4);
      slice = ns/2;
      set(gui.slider3d,'Min',1,'Max',ns,'Value',slice,'Enable','on',...
          'SliderStep',[1.0/(ns-1) 2.0/(ns-1)]);
    end
    nt = size(img,1);
    point = 10; %ceil(nt/2);
    if (nt>1)
      set(gui.slider4d,'Min',1,'Max',nt,'Value',point,'Enable','on',...
        'SliderStep',[1.0/(nt-1) 5.0/(nt-1)]);
    end
    fcnUpdateImg(num);
    set(gui.filetext(num),'String',['...',path(round(end/2):end)]);
  
end

function fcnClose(varargin)
  num = find(gui.close==varargin{1})-1;
  if (num==0)  % close all
    num = 1:5; 
    set(gui.window,'currentAxes',gui.plotaxes);  cla;
    set(gui.plotinfo,'String','');
    plotrange = 0;
    gridsize = [-1,-1];
    coords = [-1,-1];
    slice = 1;
  end
  for i=1:numel(num)
    set(gui.window,'currentAxes',gui.imgaxes(num(i)));  cla;
    set(gui.imgaxes(num(i)),'Color','black');
    set(gui.imgaxes(num(i)),'UserData',-1);
    set(gui.filetext(num(i)),'UserData',-1);
    set(gui.filetext(num(i)),'String','No file loaded');
  end
  % Find the full tab before the one we closed (if there is one; if not, go to 1)
  stillOpen = 1;
  for i=4:-1:1
    if (numel(get(gui.imgaxes(i),'UserData'))>1)
      stillOpen = i;
      break;
    end
  end
  gui.tabpanel.SelectedChild = stillOpen;
end

function fcnPlotSave(varargin)
  plotsave = 1;
  fcnUpdatePlot();
end

function fcnFitAvg(varargin)
  for n=1:numel(gui.fitavg)
    set(gui.fitavg(n),'Checked','off');
  end
  avgSize = find(gui.fitavg==varargin{1})-1;
  if avgSize>3
    avgSize=5;
  end
  set(varargin{1},'Checked','on');
  fcnUpdatePlot();
end

function fcnPlotMode(varargin)
  for n=1:numel(gui.plotmode)
    set(gui.plotmode(n),'Checked','off');
  end
  plotmode = find(gui.plotmode==varargin{1});
  set(varargin{1},'Checked','on');
  fcnUpdatePlot();
end

function fcnPlotSpec(varargin)
  for n=1:numel(gui.plotspec)
    set(gui.plotspec(n),'Checked','off');
  end
  plotspectrum = find(gui.plotspec==varargin{1})-1;
  set(varargin{1},'Checked','on');
  fcnUpdatePlot();
end

function fcnMapErr(varargin)
  for n=1:numel(gui.maperr)
    set(gui.maperr(n),'Checked','off');
  end
  selected = (gui.maperr==varargin{1});
  map_err_thres = get(gui.maperr(selected),'UserData');
  set(varargin{1},'Checked','on');
  fcnUpdatePlot();
end

function fcnMapBack(varargin)
  for n=1:numel(gui.mapback)
    set(gui.mapback(n),'Checked','off');
  end
  selected = (gui.mapback==varargin{1});
  map_bg_thres = get(gui.mapback(selected),'UserData');
  set(varargin{1},'Checked','on');
  fcnUpdatePlot();
end

function fcnQuit(varargin)
  fcnClose(gui.close(1));
  delete(gui.window);
end

function fcnSlider3d(varargin)
  fcnUpdatePlot();
end

function fcnSlider4d(varargin)
  fcnUpdatePlot();
end

function fcnColorGray(varargin)
  for n=1:numel(gui.color)
    set(gui.color(n),'Checked','off');
  end
  opt = find(gui.color==varargin{1});
  if opt==1
    colormap(gray);
  else
    colormap('default');
  end
  for num=1:5
    fcnUpdateImg(num);
  end
  set(varargin{1},'Checked','on');
end

function fcnUpdateImg(num)
  img = get(gui.imgaxes(num),'UserData');
  if numel(img)>1
    slice = round(get(gui.slider3d,'Value'));
    point = round(get(gui.slider4d,'Value'));
    set(gui.window,'CurrentAxes',gui.imgaxes(num));
    if num==5
      err = get(gui.maptext,'UserData');
      map_disp = img;
      img1 = get(gui.imgaxes(1),'UserData');
      map_disp(err > map_err_thres) = 0;
      dummy = abs(img1(end/2,:,:,:));
      maxsig = max(dummy(:));
      %map_disp(abs(img1(end/2,:,:,:)) < map_bg_thres/100.0*maxsig) = 0;
      h = imagesc(abs(map_disp(:,:,slice)));
      set(gui.maptext,'UserData',err);
      set(gui.imgaxes(1),'UserData',img1);
      clear dummy img1;
    else
      if size(img,1) == 1
        h = imagesc(abs(squeeze(img(1,:,:,slice))));
      else
        h = imagesc(abs(squeeze(img(point,:,:,slice))));
      end
    end
    set(gui.imgaxes(num),'ButtonDownFcn',@fcnUpdateCursor);
    set(h, 'HitTest', 'off')
    set(gui.imgaxes(num),'XTickLabel',[],'YTickLabel',[]);
    if coords(1) > -1
      % update crosshairs
      linObj = line([coords(1),coords(1)],[1,gridsize],'Color','w','LineWidth',1);
      set(linObj, 'HitTest', 'off');
      linObj = line([1,gridsize],[gridsize-coords(2),gridsize-coords(2)],'Color','w','LineWidth',1);
      set(linObj, 'HitTest', 'off');
    end
    set(gui.imgaxes(num),'UserData',img);
  end
  clear img
end

function fcnUpdateCursor(varargin)
  num = get(gui.tabpanel,'SelectedChild');
  if num==5
    par = get(gui.filetext(1),'UserData');    
  else
    par = get(gui.filetext(num),'UserData');
  end
  gridsize = par.nv1;
  % determine click location
  set(gui.imgaxes(num),'Units','pixels');
  pos = get(gui.imgaxes(num),'Position');
  pos(2) = pos(2) + 30;  % account for sliders
  coords = get(gui.window,'CurrentPoint');
  coords = round((coords - pos(1:2)) ./ pos(3:4) .* [gridsize,gridsize]);
  coords(2) = coords(2) - 1;
  fcnUpdatePlot();
end

function fcnUpdatePlot()
  slice = round(get(gui.slider3d,'Value'));
  point = round(get(gui.slider4d,'Value'));
  set(gui.window, 'CurrentAxes', gui.plotaxes);  cla;
  plotrange = [inf, -inf, inf, -inf];
  strInfo = {['Pixel: (', num2str(coords(1)), ',', num2str(coords(2)), ')']};
  set(gui.plotinfo, 'String', strInfo);
  if (plotsave)
    all_xaxis = cell(4,1);
    all_yaxis = cell(4,1);
    all_fitx  = cell(4,1);
    all_fity  = cell(4,1);
  end
  for num=1:4
    fcnUpdateImg(num);
    img = get(gui.imgaxes(num),'UserData');    
    if numel(img)>1 && coords(1)>-1 && size(img,1)>1
      % update plot
      par = get(gui.filetext(num),'UserData');     
      set(gui.window, 'CurrentAxes', gui.plotaxes); 
      hold on
      %xaxis = par.te + ((1:par.np/2) - par.np/4)/par.sw;
      xaxis = par.te/2 + par.des_petime + ((1:par.np/2))/par.sw;
      yaxis = 0; %zeros(size(xaxis));
      set(gca,'xdir','normal');
      for x=-avgSize:avgSize
        for y=-avgSize:avgSize
          line = img(:,gridsize-coords(2)+x,coords(1)+y,slice)';
          if (plotspectrum)
            % for now, chop off part before TE
            line = line(9:end);
            % zero-order phase correction
            line = line.*exp(-1i.*angle(line(1)));
            line_full = [conj(flipdim(line(2:end),2)), line];
            line = fftc(line_full,2);
            xaxis = (((1:numel(line)) - numel(line)/2)/2 * (1/par.at) / 128) + 4.7;
            set(gca,'Xdir','reverse');
          end
          switch plotmode
            case 1
              line = abs(line);
            case 2
              line = real(line);
            case 3
              line = imag(line);
            case 4
              line = angle(line);
          end
          yaxis = yaxis + line;
        end
      end
      plot(xaxis,yaxis,plotcolors{num});
      if ~plotspectrum
        plot(xaxis(round(point)),yaxis(round(point)),'ro','LineWidth',2);
        fitx = -1;
        fity = -1;
        params = -1;
      else
        [fitx,fity,ffrac] = fcnDoFFrac(xaxis,yaxis);
      end
      yaxis2 = img(1:end,gridsize-coords(2)+x,coords(1)+y,slice)';
      if (plotsave)
        all_xaxis{num} = xaxis;
        all_yaxis{num} = yaxis;
        all_fitx{num} = fitx;
        all_fity{num} = fity;
      end
      if numel(fitx) > 1
        strInfo = get(gui.plotinfo,'String');
        strInfo = [strInfo;{['Panel ',num2str(num), ' rough FF: ', num2str(ffrac), '%']}];
        set(gui.plotinfo, 'String', strInfo);
        plot(fitx,fity,plotcolors{mod(num,4)+1},'LineStyle','--','LineWidth',2);
      end
      plotrange(1) = min(plotrange(1), min(xaxis));
      plotrange(2) = max(plotrange(2), max(xaxis));
      plotrange(3) = min(plotrange(3), min(yaxis));
      plotrange(4) = max(plotrange(4), max(yaxis));
      %set(gui.plotaxes,'YTickLabel',[]);
      %set(gui.plotaxes,'ButtonDownFcn',@fcnUpdateLimits);
      hold off
      set(gui.filetext(num),'UserData',par);
      clear par;
    end
    clear img;
  end
  if (plotsave)
    [file,~] = uiputfile([path,'/*.*'],'Choose a filename to save plots');
    save(file,'all_xaxis','all_yaxis','all_fitx','all_fity');
    plotsave = 0;
    clear all_xaxis all_yaxis all_fitx all_fity;
  end
  if coords(1)>-1
    set(gui.window, 'CurrentAxes', gui.plotaxes);
    axis(plotrange);
  end
  fcnUpdateImg(5);
  map = get(gui.mapaxes,'UserData');    
  if numel(map)>1
    err = get(gui.maptext,'UserData');     
    set(gui.window, 'CurrentAxes', gui.mapaxes); 
    strInfo = get(gui.plotinfo,'String');
    strInfo = [strInfo;{['Mapped FF: ', num2str(map(gridsize-coords(2),coords(1),slice))]}];
    set(gui.plotinfo, 'String', strInfo);
    set(gui.maptext,'UserData',err);
    clear par;
  end
  set(gui.mapaxes,'UserData',map);
  clear map;
  num = get(gui.tabpanel,'SelectedChild');
  set(gui.window,'CurrentAxes',gui.imgaxes(num));
end

function [fitx, fity, ffrac] = fcnDoFFrac(xaxis, yaxis)
    fatpeak_ind = (xaxis > 0) & (xaxis < 2.5);
    watpeak_ind = (xaxis > 3) & (xaxis < 6);
    fatpeak_x = xaxis(fatpeak_ind);
    fatpeak_y = yaxis(fatpeak_ind);
    watpeak_x = xaxis(watpeak_ind);
    watpeak_y = yaxis(watpeak_ind);
    fitx = [fatpeak_x, watpeak_x];
    fity = [fatpeak_y, watpeak_y];
    ffrac = 100*sum(fatpeak_y) ./ sum(watpeak_y);
end

function fcnRoughFFMap(varargin)
  num = get(gui.tabpanel,'SelectedChild');
  if num==5
    return;
  end
  set(gui.window, 'CurrentAxes', gui.mapaxes);  cla;
  img = get(gui.imgaxes(num),'UserData');    
  dims = size(img);
  map = zeros(dims(2:end));
  if numel(img)>1
    par = get(gui.filetext(num),'UserData');
    slice = round(get(gui.slider3d,'Value'));
    imgmax = max(abs(img(:)));
    for z=1:size(img,4)
      for y=1:gridsize
        for x=1:gridsize
          if max(abs(img(:,x,y,z))) < map_bg_thres/100 * imgmax
            map(x,y,z) = 0;
            continue;
          end
          yaxis = 0;
          for xx=-avgSize:avgSize
            for yy=-avgSize:avgSize
              cx = mod(x+xx+gridsize-1,gridsize)+1;
              cy = mod(y+yy+gridsize-1,gridsize)+1;           
              line = img(9:end,cx,cy,z)';
              line = line.*exp(-1i.*angle(line(1)));
              line_full = [conj(flipdim(line(2:end),2)), line];
              line = fftc(line_full,2);
              switch plotmode
                case 1
                  line = abs(line);
                case 2
                  line = real(line);
                case 3
                  line = imag(line);
                case 4
                  line = angle(line);
              end
              xaxis = (((1:numel(line)) - numel(line)/2)/2 * (1/par.at) / 128) + 4.7;
              yaxis = yaxis + line;
            end
          end
          yaxis = yaxis / (avgSize+1)^2;
          try
            [fitx,~,ffrac] = fcnDoFFrac(xaxis,yaxis);
          catch exception
            disp(exception);
          end
          if numel(fitx) > 1
            map(x,y,z) = ffrac;
          end   
        end
      end
    end
    set(gui.filetext(num),'UserData',par);
    clear par;
    set(gui.maptext,'String',['Rough FF Map for Panel ',num2str(num)]);
    set(gui.mapaxes,'UserData',map);
    set(gui.tabpanel,'SelectedChild',5);
    set(gui.window,'CurrentAxes',gui.mapaxes);
    fcnUpdateImg(5);
  end
  set(gui.imgaxes(num),'UserData',img);
  clear img;
end

function fcnDiffMap(varargin)
  num = get(gui.tabpanel,'SelectedChild');
  if num==5
    return;
  end
  set(gui.window, 'CurrentAxes', gui.mapaxes);  cla;
  img  = get(gui.imgaxes(num),'UserData');    
  img2 = get(gui.imgaxes(num+1),'UserData');    
  dims = size(img);
  diffmap = zeros(dims(2:end));
  differr = zeros(dims(2:end));
  if numel(img)>1
    par = get(gui.filetext(num),'UserData');     
    for z=1:par.nv2
      for y=1:gridsize
        for x=1:gridsize
          yaxis1 = abs(img(end/2:end-plotchop,x,y,z));
          yaxis2 = abs(img2(end/2:end-plotchop,x,y,z));
          diffmap(x,y,z) = rmse(yaxis1,yaxis2);
        end
      end
    end
    set(gui.filetext(num),'UserData',par);
    clear par;
    set(gui.maptext,'String',['Difference Map for Panel ',num2str(num)]);
    set(gui.maptext,'UserData',differr);
    set(gui.mapaxes,'UserData',diffmap);
    set(gui.tabpanel,'SelectedChild',5);
    set(gui.window,'CurrentAxes',gui.mapaxes);
    fcnUpdateImg(5);
  end
  set(gui.imgaxes(num),'UserData',img);
  clear img;
end

function fcnROI(varargin)
  map = get(gui.mapaxes,'UserData');
  err = get(gui.maptext,'UserData');
  map_thres = map;
  img = get(gui.imgaxes(1),'UserData');
  map_thres(err > map_err_thres) = 0;
  dummy = abs(img(end/2,:,:,:));
  maxsig = max(dummy(:));
  map_thres(abs(img(end/2,:,:,:)) < map_bg_thres/100.0*maxsig) = 0;
  set(gui.maptext,'UserData',err);
  r2star = [];
  for x=-2:2
    for y=-2:2
  %for x=-1:1
  %  for y=-1:1
      val = map_thres(gridsize-coords(2)+x,coords(1)+y,slice);
      if val > 0
        r2star = [r2star, val];
      end
    end
  end
  r2starROI = mean(r2star);
  errROI    = std(r2star);
  strInfo = ['R2* of ROI: ', num2str(r2starROI), ' +/- ', num2str(errROI)];
  set(gui.plotinfo, 'String', strInfo);
  set(gui.maptext,'UserData',map);
  set(gui.maptext,'UserData',err);
  set(gui.imgaxes(1),'UserData',img);
  clear img map_thres;
end

function fcnLoadMap(varargin)
  [file,path] = uigetfile([path,'/*.*'],'Select a .mat file containing R2* map');
  if size(strfind(file,'mat'),1)>0
    err = 0;
    map_saved = 0;
    load([path,file]);
    set(gui.maptext,'String',['Saved R2* Map:', file]);
    set(gui.maptext,'UserData',err);
    set(gui.mapaxes,'UserData',map_saved);
    set(gui.tabpanel,'SelectedChild',5);
    set(gui.window,'CurrentAxes',gui.mapaxes);
    fcnUpdateImg(5);
  end
end

function fcnSaveMap(varargin)
  map = get(gui.mapaxes,'UserData');
  err = get(gui.maptext,'UserData');
  if numel(map)>1
    [file,~] = uiputfile([path,'/*.*'],'Choose a filename to save R2* map');
    if (numel(file)>1)
      map_saved = map;
      img = get(gui.imgaxes(1),'UserData');
      map_saved(err > map_err_thres) = 0;
      dummy = abs(img(end/2,:,:,:));
      maxsig = max(dummy(:));
      map_saved(abs(img(end/2,:,:,:)) < map_bg_thres/100.0*maxsig) = 0;
      set(gui.imgaxes(1),'UserData',img);
      clear dummy img;
      save(file,'map_saved','err');        
    end
  end
  set(gui.mapaxes,'UserData',map);
  set(gui.maptext,'UserData',err);
end

function fcnSaveImg(varargin)
  [file,~] = uiputfile([path,'/*.*'],'Choose a filename to save image');
  if (numel(file)>1)
    num = get(gui.tabpanel,'SelectedChild');
    fig2 = figure('Position',[200,0,530,560],'visible','off');
    newax = copyobj(gui.imgaxes(num),fig2);
    if strcmp(get(gui.color(1),'Checked'),'on')
      colormap(gray);
    else
      colormap('default');
    end
    F = getframe(fig2);
    F2 = F.cdata;
    F2 = F2(31:end,:,:);
    imwrite(F2,['~/',file],'Resolution',300,'Compression','lzw'); 
    close(fig2);
  end
end

function fcnClearCH(varargin)
  num = get(gui.tabpanel,'SelectedChild');
  coords = [-1,-1];
  fcnUpdateImg(num);
end

end
