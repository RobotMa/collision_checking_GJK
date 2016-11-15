% Example script for GJK2D function
%   Animates two objects on a collision course and terminates animation
%   when they hit each other. Loads vertex and face data from
%   SampleShapeData.m. See the comments of GJK.m for more information
%
%   Most of this script just sets up the animation and transformations of
%   the shapes. The only key line is:
%   collisionFlag = GJK(S1Obj,S2Obj,iterationsAllowed)
%
%   Qianli Ma, 2016
%%
clc;clear all;close all

addpath('~/qianli_workspace/src/rvctools/robot')

%%
%How many iterations to allow for collision detection.
iterationsAllowed = 2;

% Make a figure
fig = figure;
hold on

% Load sample vertex data for two convex polygon
SampleShapeData2D;

% Make shape 1
S1.Vertices = V1;

% Make shape 2
S2.Vertices = V2;

%Move them through space arbitrarily.
S1Coords = S1.Vertices;
S2Coords = S2.Vertices;

S1Rot = rot2(0); % Accumulate angle changes

% Make a random rotation matix to rotate shape 1 by every step
S1Angs = 0.1*rand; % Euler angles
S1RotDiff = rot2(S1Angs);

S2Rot = rot2(0);

% Make a random rotation matix to rotate shape 2 by every step
S2Angs = 0.1*rand; % Euler angles
S2RotDiff = rot2(S2Angs);


%%
% Animation loop. Terminates on collision.
for i = 3:-0.01:0.2
    S1Rot = S1RotDiff*S1Rot;
    S2Rot = S2RotDiff*S2Rot;
    
    S1.Vertices = (S1Rot*S1Coords')' + i;
    S2.Vertices = (S2Rot*S2Coords')' + -i;
    
    % Do collision detection
    collisionFlag = GJK2D(S1,S2,iterationsAllowed);
    
    drawnow;
    
    if collisionFlag
        hold on
        fill(S1.Vertices(:,1), S1.Vertices(:,2),'b')
        fill(S2.Vertices(:,1), S2.Vertices(:,2),'b')
        t = text(3,3,3,'Collision!','FontSize',30);
        
        break
    else
        hold on
        fill(S1.Vertices(:,1), S1.Vertices(:,2),'r')
        fill(S2.Vertices(:,1), S2.Vertices(:,2),'g')
        hold off
    end
end
