function [xopt, fopt] = es_off(stopeval)
% [xp, fp, stat] = es(fitnessfct, n, lb, ub, stopeval)
  % Strategy parameters
  n = 30;
  
  ub = 10000;
  lb = 0;
  
  m = 100;
  l = 400;
  t = 1/sqrt(n);
  
  sigma = 1/ub;
  evalcount = 0;
  n_success = 0; % the number of successful mutation within a bin
  
  % Initialize
  xp = randi([lb, ub], m, n);
  
  for h = 1:m
    fp = str2double(optical(xp(h, :)));
  end
  
  [fopt, index] = min(fp);
  xopt = xp(index,:);
        
  % Statistics administration
  stat.name = '(M, L)-ES';
  stat.evalcount = 0;
  stat.histsigma = zeros(1, stopeval);
  stat.histf = zeros(1, stopeval);

  % Evolution cycle
  while evalcount < stopeval
      
    sigma_prime = sigma * exp(t * normrnd(0,1));  
    combinations = randi([1, m], l, 2); 
    
    for i = 1:l
        pair_1 = xp(combinations(i, 1), :);
        pair_2 = xp(combinations(i, 2), :);
        
        for j = 1:n
            if rand < 0.5
                offspring(i, j) = pair_1(1, j) + (sigma_prime * normrnd(0,1));
            else
                offspring(i, j) = pair_2(1, j) + (sigma_prime * normrnd(0,1));
            end
        end
        
        % Generate offspring and evaluate
        fo_(i) = str2double(optical(offspring(i,:)));
        
        sorting{i, 1} = offspring(i,:);
        sorting{i, 2} = fo_(i);
        sorting{i, 3} = i;
        
        [ranks_ordered, idx] = sort(cell2mat(sorting(:,2)));
        sorted_offspring = sorting(idx,:);
        
        evalcount = evalcount + 1;
        % Statistics administration
    
        
        stat.histsigma(evalcount) = sigma_prime; % stepsize history
        stat.histf(evalcount) = fo_(i); % fitness history
 
        % if desired: plot the statistics
        clf
        subplot(2, 1, 1)
        semilogy(1:evalcount, stat.histf(1:evalcount), 'k-')
        title('fitness')
        xlabel('evalcount')
%     
        subplot(2, 1, 2)
        semilogy(1:evalcount, stat.histsigma(1:evalcount), 'r--')
        title('sigma')
        xlabel('evalcount')
        drawnow()
    end
    
    sigma = sigma_prime;
    
    xo = cell2mat(sorted_offspring(:,1))
    fo = cell2mat(sorted_offspring(:,2))
    
    xp = xo(1:m,:);
    fp = fo(1:m,:);
    
    [fopt_, optindex] = min(fp);
    if (fopt_ < fopt) %Keep track of the best
        xopt = xp(index,:);
        fopt = fopt_;
    end
    
    display('Hello')
    display(fopt)
        
     
  end

end

