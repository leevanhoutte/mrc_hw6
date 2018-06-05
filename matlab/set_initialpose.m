function [] = set_initialpose(x,y,yaw)
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

end