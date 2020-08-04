function GWRun
% A global workspace with an internal loop using spiking neurons
%
% Murray Shanahan
% July 2006 - September 2006
%
% GWRun reads in a previously saved network, generated by GWConnect, and
% runs it for a given number of time steps, supplying external stimuli
% during the run when required


% close all;

N = 16;     % Workspace areas are N by N matrices
Nc = 32;    % Cortical columns are Nc by Nc matrices
Dmax = 40;  % Maximum propagation delay

load('Network.mat','layer');

% Read in input stimulus
Image1 = imread('BlobNWSmall.bmp');

% Normalise pixels (images are 16 colour bitmaps)
Image1 = double(Image1) ./ 15;

% Invert y axes for proper plotting
Image1(1:N,:) = Image1(N:-1:1,:);

Ib = 2;       % base current
Iwpulse = 25; % pulse current

% Initial membrane potentials
for lr=1:length(layer)
   layer{lr}.v = -65*ones(layer{lr}.rows,layer{lr}.columns);
   layer{lr}.u = layer{lr}.b.*layer{lr}.v;
end

% Clear lists of spikes
for lr=1:length(layer)
   layer{lr}.firings = [];
end


% SIMULATE

for t=1:300

   % Display time every 10ms
   if mod(t,10) == 0
      t
   end
   
   for lr=1:length(layer)
      layer{lr}.I = Ib*ones(layer{lr}.rows,layer{lr}.columns);
   end
   
   % Input stimulus is a single set of pulses at t = 20 delivered
   % directly to W1
   if (t== 20)
      layer{1}.I = layer{1}.I+Image1*Iwpulse;
   end
   
   % Introduce noise in columns
   layer{6}.I = 1*randn(Nc,Nc);    
   layer{7}.I = 1*randn(Nc,Nc);   
   layer{8}.I = 1*randn(Nc,Nc);    

   for lr=1:length(layer);
      layer = update(layer,lr,t,Dmax);
      % plot_layer(layer,lr,t);
   end
   
   % waitforbuttonpress;

   drawnow;
      
end

save('NetMovie.mat','layer');

end