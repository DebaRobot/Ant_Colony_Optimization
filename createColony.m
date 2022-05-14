function colony = createColony(graph, colony, antNo, tau, eta, alpha, beta)

nodeNo = graph.n;

for i = 1 : antNo
    initial_node = randi([1, nodeNo]);%Select a random node
    colony.ant(i).tour(1) = initial_node;
     
    for j = 2 : nodeNo
        currentNode = colony.ant(i).tour(end);
        
        P_allNodes = tau( currentNode , :  ) .^ alpha .* eta( currentNode , :  )  .^ beta;
        P_allNodes(colony.ant(i).tour) = 0 ;  % assing 0 to all the nodes visited so far
        P = P_allNodes ./ sum(P_allNodes);
        
        nextNode = rouletteWheel(P);
        colony.ant(i).tour = [colony.ant(i).tour, nextNode];
        
    end
    
    %Complete the tour
    colony.ant(i).tour = [colony.ant(i).tour, colony.ant(i).tour(1)];
    
end

end
