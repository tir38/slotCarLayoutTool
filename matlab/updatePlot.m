function [] = updatePlot(track)


clf % clear current figure
plot(track(:,1), track(:,2), 'bo') % plot left track
hold on
plot(track(:,3), track(:,4), 'ko') % plot center track
hold on
plot(track(:,5), track(:,6), 'ro') % plot right track
axis equal
hold off
commandwindow