function [] = MedianTracker( AEDAT, timeStep )
%{
This function get the AEDAT file and a value of time (us) and return the
frames who was formed by the sum of the spikes along the timeStamp and put 
rectangule in the region with more variance (sorry my english)
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
    
    xposf = medfilt1(double(eventsForFrame.x),10);
    yposf = medfilt1(double(eventsForFrame.y),10);
    xposf = uint8(xposf);
    yposf = uint8(yposf);
    for i=1:length(eventsForFrame.x)
       frame(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) =...
           frame(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) +...
           eventsForFrame.polarity(i);  
    end

    for z=1:AEDAT.info.deviceAddressSpace(1)
        Hx = horzcat(Hx,length(xposf(xposf==z)));
        Hy = horzcat(Hy,length(yposf(yposf==z)));
    end
    
    limiar.x = uint32(0.001*length(xposf));    
    TrackingBox_P1.x = find(Hx>=limiar.x,1, 'first');
    TrackingBox_P2.x = find(Hx>=limiar.x,1, 'last');
    
    limiar.y = uint32(0.001*length(yposf));
    TrackingBox_P1.y =  find(Hy>=limiar.y,1, 'first');
    TrackingBox_P2.y =  find(Hy>=limiar.y,1, 'last');
    
    frame(TrackingBox_P1.x:TrackingBox_P2.x,TrackingBox_P1.y:TrackingBox_P1.y+1) = 0;
    frame(TrackingBox_P1.x:TrackingBox_P1.x+1,TrackingBox_P1.y:TrackingBox_P2.y) = 0;
    frame(TrackingBox_P1.x:TrackingBox_P2.x,TrackingBox_P2.y:TrackingBox_P2.y+1) = 0;
    frame(TrackingBox_P2.x:TrackingBox_P2.x+1,TrackingBox_P1.y:TrackingBox_P2.y) = 0;

    frame = imrotate(frame,90);
    imshow(frame);

    Hx = []; 
    Hy = [];
    
    frame = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1])+ 0.5;
end 


end

