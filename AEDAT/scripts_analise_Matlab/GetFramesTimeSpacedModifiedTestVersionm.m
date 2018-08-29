function [ frames ] = GetFramesTimeSpacedModifiedTestVersionm( AEDAT, timeStep )
%{
This function get the AEDAT file and a value of time (us) and return the
frames who was formed by the sum of the spikes along th timeStamp (sorry my
english)
%}
t = AEDAT.data.polarity.timeStamp;
to = min(AEDAT.data.polarity.timeStamp); 
tf = max(AEDAT.data.polarity.timeStamp); 
deltaT = (tf - to); 

numFrames = deltaT/timeStep;
frameTimes = to + timeStep*0.5 : timeStep : tf;
frameBoundaryTimes = [to frameTimes + timeStep * 0.5];
numEvents = length(t);

frame = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
        
frame = frame + 0.5;

frameB = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
        
frameB = frameB + 0.5;

frameC = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
        
frameC = frameC + 0.5;

frames = {zeros(128,128)};
       
Hx = [];
Hy = [];
 figure();
for frameIndex = 1:numFrames
    
    firstIndex = find(t >= frameBoundaryTimes(frameIndex), 1, 'first');
    lastIndex = find(t <= frameBoundaryTimes(frameIndex + 1), 1, 'last');

    selectedLogical = [false(firstIndex - 1, 1); ...
                        true(lastIndex - firstIndex + 1, 1); ...
                        false(numEvents - lastIndex, 1)];

    eventsForFrame = struct;
    eventsForFrame.x = AEDAT.data.polarity.x(selectedLogical);
    eventsForFrame.y = AEDAT.data.polarity.y(selectedLogical);
    eventsForFrame.polarity = AEDAT.data.polarity.polarity(selectedLogical)-0.5;
    
    xposf = medfilt1(double(eventsForFrame.x),70);
    yposf = medfilt1(double(eventsForFrame.y),70);
    xposf = uint8(xposf);
    yposf = uint8(yposf);
    for i=1:length(eventsForFrame.x)
       %frame(xposf(i,1)+1,yposf(i,1)+1) = frame(xposf(i,1)+1,yposf(i,1)+1) + eventsForFrame.polarity(i);  
       frameB(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) = frameB(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) + eventsForFrame.polarity(i);  
    end
            
%     coordenadas(:,:) = {[eventsForFrame.x(:,1)+1,eventsForFrame.y(:,1)+1]};
%     
%     m = mode(coordenadas{1});
%         
%     h = histogram(eventsForFrame.polarity);
%     f = histogram(frame);
%     h.Normalization = 'countdensity';
%     valores = h.Data;
%     
%     mediana = median(coordenadas{1});
%    

%{
---------------------------------------------------------------------------
quase funciona ( necessario descobrir como fazer o histograma sem plotar
---------------------------------------------------------------------------
%}
%       limiar = 0.1*length(xposf);
%       
% %        figure();
%       hx = histogram(xposf,10);
%       TrackingBox_P1.IndexOfx = find(hx.Values>limiar,1, 'first');
%       TrackingBox_P2.IndexOfx = find(hx.Values>limiar,1, 'last');
%       TrackingBox_P1.x = hx.BinEdges(TrackingBox_P1.IndexOfx);
%       TrackingBox_P2.x = hx.BinEdges(TrackingBox_P2.IndexOfx);
% %       figure();
%       hy = histogram(yposf,10);
%       TrackingBox_P1.IndexOfy = find(hy.Values>limiar,1, 'first');
%       TrackingBox_P2.IndexOfy = find(hy.Values>limiar,1, 'last');
%       TrackingBox_P1.y = hy.BinEdges(TrackingBox_P1.IndexOfy);
%       TrackingBox_P2.y = hy.BinEdges(TrackingBox_P2.IndexOfy);
%{
---------------------------------------------------------------------------
---------------------------------------------------------------------------
%}

%       modax = mode(xposf,3);
%       moday = mode(yposf,3);
%       limiar = 0.1*max(xposf);
%       
%       TrackingBox_P1.IndexOfx = find(modax>limiar,1, 'first');
%       TrackingBox_P2.IndexOfx = find(modax>limiar,1, 'last');
%       TrackingBox_P1.x = xposf(TrackingBox_P1.IndexOfx);
%       TrackingBox_P2.x = xposf(TrackingBox_P2.IndexOfx);
%       
%       TrackingBox_P1.IndexOfy = find(moday>limiar,1, 'first');
%       TrackingBox_P2.IndexOfy = find(moday>limiar,1, 'last');
%       TrackingBox_P1.y = yposf(TrackingBox_P1.IndexOfy);
%       TrackingBox_P2.y = yposf(TrackingBox_P2.IndexOfy);


%     IndexP1.x = find((eventsForFrame.x(:,1)+1) == m(1,1));
%     for i = 1:length(IndexP1.x)
%         posyP1(i) = eventsForFrame.y(IndexP1.x(i),1)+1;
%     end
%     IndexP1.y = max(posyP1(i));
%     P1.x = m(1,1);
%     P1.y = IndexP1.y(end);
%     
%     IndexP2.y = find((eventsForFrame.y(:,1)+1) == m(1,2));
%     for i = 1:length(IndexP2.y)
%         posxP2(i) = eventsForFrame.x(IndexP2.y(i),1)+1;
%     end
%     IndexP2.x = max(posxP2(i));
%     P2.y = m(1,1);
%     P2.x = IndexP2.x(end);
%     
%    frame(TrackingBox_P1.x:TrackingBox_P2.x,TrackingBox_P1.y:TrackingBox_P2.y) = 0;
%    

    
%     figure();
%     imshow(frame);

   
    
%     figure();
%     plot(Hx);
%     figure();
%     plot(Hy);
    
%     limiar.x = uint32(0.025*length(xposf));    
%     TrackingBox_P1.IndexOfx = find(Hx>=limiar.x,1, 'first');
%     TrackingBox_P2.IndexOfx = find(Hx>=limiar.x,1, 'last');
%     TrackingBox_P1.x = xposf(TrackingBox_P1.IndexOfx);
%     TrackingBox_P2.x = xposf(TrackingBox_P2.IndexOfx);
%     
%     limiar.y = uint32(0.025*length(yposf));
%     TrackingBox_P1.IndexOfy = find(Hy>=limiar.y,1, 'first');
%     TrackingBox_P2.IndexOfy = find(Hy>=limiar.y,1, 'last');
%     TrackingBox_P1.y = yposf(TrackingBox_P1.IndexOfy);
%     TrackingBox_P2.y = yposf(TrackingBox_P2.IndexOfy);

    for z=1:AEDAT.info.deviceAddressSpace(1)
        Hx = horzcat(Hx,length(xposf(xposf==z)));
        Hy = horzcat(Hy,length(yposf(yposf==z)));
    end
    
    limiar.x = uint32(0.025*length(xposf));    
    TrackingBox_P1.x = find(Hx>=limiar.x,1, 'first');
    TrackingBox_P2.x = find(Hx>=limiar.x,1, 'last');
    
    limiar.y = uint32(0.025*length(yposf));
    TrackingBox_P1.y =  find(Hy>=limiar.y,1, 'first');
    TrackingBox_P2.y =  find(Hy>=limiar.y,1, 'last');
    
    frameB(TrackingBox_P1.x:TrackingBox_P2.x,TrackingBox_P1.y:TrackingBox_P1.y+1) = 0;
    frameB(TrackingBox_P1.x:TrackingBox_P1.x+1,TrackingBox_P1.y:TrackingBox_P2.y) = 0;
    frameB(TrackingBox_P1.x:TrackingBox_P2.x,TrackingBox_P2.y:TrackingBox_P2.y+1) = 0;
    frameB(TrackingBox_P2.x:TrackingBox_P2.x+1,TrackingBox_P1.y:TrackingBox_P2.y) = 0;

%     frameC = frame;
%     frameC((TrackingBox_P1.x:TrackingBox_P2.x)+20,(TrackingBox_P1.y:TrackingBox_P2.y)+20) = frameB((TrackingBox_P1.x:TrackingBox_P2.x)+20,(TrackingBox_P1.y:TrackingBox_P2.y)+20);
    frameB = imrotate(frameB,90);
    imshow(frameB);
%     rectangle('Position',[TrackingBox_P1.x,TrackingBox_P1.y,TrackingBox_P2.x,TrackingBox_P2.y]);

    
    Hx = []; 
    Hy = [];
    
    frames = cat(4,frames,frame);
    
    frame = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
        
    frame = frame + 0.5;
    
    frameB = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
        
    frameB = frameB + 0.5;
    
    frameC = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
        
    frameC = frameC + 0.5;
     

end 


end

