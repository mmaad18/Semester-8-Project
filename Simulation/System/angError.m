function angleOut = angError(angleIn)

sign = 0;

if angleIn >= 0
    sign = 1;
else
    sign = -1;
end

%angleIn = abs(angleIn);

% if abs(angleIn) > 2*pi
%     angleIn = angleIn - 2*pi;
% end

if abs(angleIn)/pi > 1
    %angleIn = pi - mod(angleIn, pi);
    angleIn = angleIn - sign*2*pi;
end

%angleOut = sign*angleIn;
angleOut = angleIn;

end

