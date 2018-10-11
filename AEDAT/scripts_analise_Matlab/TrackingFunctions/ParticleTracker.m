function [ ] = ParticleTracker( AEDAT, timeStep )

%% declaracao variaveis
index = struct;
index.x = [];
index.y = [];
particulas = {struct};
particulas{1}.time = 0;
massa = 1;
%%
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
    eventsForFrame.time = AEDAT.data.polarity.timeStamp(selectedLogical);
    aux_x = eventsForFrame.x;
    aux_y = eventsForFrame.y;
%     
%     for j = 1: length(eventsForFrame.x)
%        for k = 1: length(eventsForFrame.x)
%           
%        end
%     end
    
    for j=1:length(aux_x)
      index.x = find(aux_x(:) == (aux_x(j)+1));
      index.x = vertcat(index.x,find(aux_x(:) == (aux_x(j)-1)));
      for k = 1:length(index.x)
          index.y = find(aux_y(:) == (aux_y(index.x(k))+1));
          index.y = vertcat(index.y,find(aux_y(:) == (aux_y(index.x(k))-1)));
      end
      if(isempty(index.x) && isempty(index.y))
%           minorT = -1*(particulas{end}.time - double((eventsForFrame.time(j))))/timeStep;
%           point = [(massa*(eventsForFrame.x(j)^(uint16(minorT)))),(massa*(eventsForFrame.y(j)^(uint16(minorT))))];
          particulas{j}.cod = j;
          particulas{j}.massa = massa;
          particulas{j}.pos_x = eventsForFrame.x(j);
          particulas{j}.pos_y = eventsForFrame.y(j);
          particulas{j}.point.x = 0;
          particulas{j}.point.y = 0;
          particulas{j}.time = eventsForFrame.time(j);
      else if(~isempty(index.x) && ~isempty(index.y))
          particulas{j}.cod = j;
          particulas{j}.massa = length(index.x);
          particulas{j}.pos_x = eventsForFrame.x(j);
          particulas{j}.pos_y = eventsForFrame.y(j);
          particulas{j}.point.x = 0;
          particulas{j}.point.y = 0;
          particulas{j}.time = eventsForFrame.time(j);
%           aux_x = setdiff(aux_x,aux_x(index.x(:)));
%           aux_y = setdiff(aux_y,aux_y(index.y(:)));
           end
    end
  i = 1;  
    
end


end

