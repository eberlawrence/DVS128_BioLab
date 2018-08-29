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

frames = {zeros(128,128)};
       

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
    
    xposf = medfilt1(double(eventsForFrame.x),5);
    xposf = medfilt1(xposf);
    yposf = medfilt1(double(eventsForFrame.y),5);
    yposf = medfilt1(yposf);
    pol =  medfilt1(double(eventsForFrame.polarity),5);
    for i=1:length(eventsForFrame.x)
%         if(frame(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) == 0)
              frame(xposf(i,1)+1,yposf(i,1)+1) = frame(xposf(i,1)+1,yposf(i,1)+1) + pol(i);  
%         end
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
%     moda = mode(coordenadas{1});
    
    
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
%    frame(P2.x:P1.x,P1.y:P2.y) = 0;
%    

    
    [x,y] = find(frame > 1);
    for j = 1:length(x)
        frame(x(j,1),y(j,1)) = 1;
    end
   
    [x,y] = find(frame < 0);
    for j = 1:length(x)
        frame(x(j,1),y(j,1)) = 0;
    end
    
    figure();
    imshow(frame);

  
    frame = zeros([AEDAT.info.deviceAddressSpace(2) ...
            AEDAT.info.deviceAddressSpace(1) ...
            1]);
        
    frame = frame + 0.5;

     frames = cat(4,frames,frame);

end 
end

