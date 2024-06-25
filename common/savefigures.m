% savefigures Save figures to current working directory inside 'images' folder in EPS format with color

% Define the folder name
FolderName = fullfile(pwd, 'images');

% Check if the folder exists, and create it if it doesn't
if ~exist(FolderName, 'dir')
    mkdir(FolderName);
end

% Retrieve all figure handles currently open
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');

% Loop through each figure and save as EPS
for iFig = 1:length(FigList)
    FigHandle = FigList(iFig);         % Get handle to the figure
    FigName   = get(FigHandle, 'Name'); % Get the figure name
    saveas(FigHandle, fullfile(FolderName, [FigName, '.eps']), 'epsc'); % Save figure as EPS
end
