clear all
close all
clc

%% Problem preparation
% Create the graph
graph = createGraph();

% Draw the graph
figure
subplot(1,3,1)
drawGraph(graph);

%% ACO algorithms

%% Initial parameters of ACO 
maxiter = 500;
antNo = 20;

tau0 = 10 * 1 / (  graph.n * mean( graph.edges(:)  )  );  % Initial phromone concentration

tau = tau0 * ones( graph.n , graph.n); % Phromone matirx 
eta = 1./ graph.edges;  % desirability of each edge 

rho = 0.05; % Evaporation rate 
alpha = 2;  % Phromone exponential parameters 
beta = 1;  % Desirability exponetial paramter



%% Main Loop of ACO
bestFitness =inf;
bestTour = [];
for t = 1 : maxiter
    %Create ants
    
    colony = [];
    colony = createColony(graph, colony, antNo, tau, eta, alpha, beta);

    
    % Calculate the fitness values of all ants 
    for i = 1 : antNo 
        colony.ant(i).fitness = fitnessFunction(colony.ant(i).tour , graph );
    end
    
    % Find the best ant (queen)
    allAntsFitness = [ colony.ant(:).fitness ];
    [ minVal , minIndex ] = min( allAntsFitness );
    if minVal < bestFitness 
        bestFitness = colony.ant(minIndex).fitness;
        bestTour = colony.ant(minIndex).tour;
    end
    
    colony.queen.tour = bestTour;
    colony.queen.fitness = bestFitness;
    
    %Update pheromenon matrix
    tau = updatePhromone(tau, colony);
    
    %Evaporation
    tau = (1 - rho).*tau;
    
    %Display the result
    outmsg = ['Iteration # ', num2str(t),'Shortest Length = ', num2str(colony.queen.fitness)];
    disp(outmsg)
    
    %Visualizing the graph best tour and update phermone matrix
    subplot(1,3,2);
    cla
    drawBestTour(colony, graph);
    
    subplot(1,3,3);
    cla
    drawPhromone(tau, graph);
    
    drawnow
    
end


