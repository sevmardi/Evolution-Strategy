function f = optical(x)
% design of multilayer optical filter 
% Input:
% 	x : 1-d real-valued row vector 
	cmd = ['./optical.exe ', num2str(x)];
	[status, cmdout] = system(cmd);
	f = cmdout
end
