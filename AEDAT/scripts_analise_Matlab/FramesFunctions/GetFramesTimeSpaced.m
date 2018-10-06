function [ frames ] = GetFramesTimeSpaced( AEDAT, timeStep )
%{
This function get the AEDAT file and a value of time (us) and return the
frames who was formed by the sum of the spikes along th timeStamp (sorry my
english)
%}
t = AEDAT.data.polarity.timeStamp;
to = min(AEDAT.data.polarity.timeStamp); 
tf = max(AEDAT.data.polarity.timeStamp); 
deltaT = (tf - to); 

xdim = AEDAT.info.deviceAddressSpace(2);
ydim = AEDAT.info.deviceAddressSpace(1);

numFrames = deltaT/timeStep;
frameTimes = to + timeStep*0.5 : timeStep : tf;
frameBoundaryTimes = [to frameTimes + timeStep * 0.5];
numEvents = length(t);

frame = zeros([xdim,ydim,1]);
        
frame = frame + 0.5;

frames = {zeros(128,128)};
       
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
    
    for i=1:length(eventsForFrame.x)
         frame(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) = ...
             frame(eventsForFrame.x(i,1)+1,eventsForFrame.y(i,1)+1) ...
             + eventsForFrame.polarity(i);  
    end
    
   
 
     frame = imrotate(frame,90);
    imshow(frame);
  
   frame = zeros([xdim,ydim,1]);
        
   frame = frame + 0.5;

   frames = cat(4,frames,frame);

end 
end

