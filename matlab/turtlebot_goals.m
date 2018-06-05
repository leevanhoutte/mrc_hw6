%% Lee Van Houttte
%ME4823
%Assignment 6 Exercise #3


% ipaddress = '192.168.11.107;
% rosinit(ipaddress);
rosshutdown
rosinit

%% Set goals
x = 0; y = 0; yaw = 0;
% set_initialpose(x,y,yaw);
% Create publisher
chatpub = rospublisher('/amcl_pose','geometry_msgs/PoseWithCovarianceStamped');

% Create Geometry message
covariance = [0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.06853891945200942];
msg = rosmessage(chatpub);
msg.Pose.Covariance = covariance;
msg.Pose.Pose.Position.X = x;
msg.Pose.Pose.Position.Y = y;
q = eul2quat(deg2rad([yaw 0 0]));
msg.Pose.Pose.Orientation.W = q(1);
msg.Pose.Pose.Orientation.X = q(2);
msg.Pose.Pose.Orientation.Y = q(3);
msg.Pose.Pose.Orientation.Z = q(4);

% Publish message 
send(chatpub,msg);

%% 
% N = robotics.ros.Node('noah','192.168.11.112')
% [client] = robotics.ros.SimpleActionClient(N,'/move_base','move_base_msgs/MoveBase')
[client,Goal] = rosactionclient('/move_base','move_base_msgs/MoveBase');

%% Goal positions
x = [2 4 4 0]';
y = [-2 -2 1.5 0]';
yaw = [-90 -90 90 180]';
q = eul2quat(deg2rad([yaw zeros(4,1) zeros(4,1)]));

%% Send turtle_bot to goals
for i = 1:4
    Goal.TargetPose.Header.FrameId = 'map'
    Goal.TargetPose.Pose.Position.X = x(i);
    Goal.TargetPose.Pose.Position.Y = y(i);
    Goal.TargetPose.Pose.Orientation.W = q(i,1);
    Goal.TargetPose.Pose.Orientation.X = q(i,2);
    Goal.TargetPose.Pose.Orientation.Y = q(i,3);
    Goal.TargetPose.Pose.Orientation.Z = q(i,4);

    client.FeedbackFcn = [];
    
    [resultMsg,~,~] = sendGoalAndWait(client,Goal)
    waitForServer(client);

end