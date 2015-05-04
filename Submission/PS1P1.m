%% PROBLEM 1. 
clear all
close all 
clc
%% 1.5 Gauss Seidel Iteration
%Initialize the problem
disp('Initializing problem... ');
a = 3;
b = 0.5;
c = 1; d = 1;
A = [1 b; 1 -d ];
Z = [a; c];             % Z is the "b" vector

% Starting point for the solution

x_init = [0.1  0.1]';
maxit = 100000;
tol=1e-6;

%Iteration with dx: dx = Q^-1(b-Ax_(i-1))
disp('Gauss Seidel iteration. ');
Q = tril(A);            % create lower triangular matrix of A
Qinv = inv(Q);
X = zeros(2,maxit+1);   
X(:, 1) = x_init;
x =  x_init;

for i = 1:maxit  
    dx= Qinv * (Z-A*x);
    x = x + dx;
    X(:, i+1) = x; 
        if norm(dx) < tol ,  break, end
        if i == maxit, disp('No convergence'), end
end     
disp('Plotting..');
figure(1)
hold on 
convX=X(:, 1:i+1);
plot(convX(1,:)); 
plot(convX(2,:))
title(['Convergence of the price and quantity using GS ' ]);
legend('Price','Quantity');
xlabel('Iteration');
disp(['The number of iterations used before convergence: ' , num2str(i)]);
hold off
saveas(1,['PS1P1_convergence.pdf']);
disp('Please press any key to continue.');
pause('on');
pause;
%% No convergence case
disp('No convergence case: Initializing problem...  ');
A = [1 -d ; 1 b  ];
Z = [c; a];

%Starting point for the solution

x = [0.1  0.1]';

%Iteration with dx: dx = Q^-1(b-Ax_(i-1))

maxit = 100000;
tol=1e-6;
Q = tril(A);
% eig(Q)
Qinv = inv(Q);
X = zeros(2 , maxit+1); %Interation values of x
X(:, 1) = x;
disp('No convergence case: GS iteration...  ');
for i = 1:maxit  
    dx= Qinv * (Z-A*x);
    x = x + dx;
    X(:, i+1) = x; 
        if norm(dx) < tol ,  break, end
        if i == maxit, disp('No convergence'), end
end

a = input('Would you like to illustrate the no convergence in graph? Please type y or n and press enter to continue.','s') ;
if strcmpi(a,'y')
% To illustrate that there is no convergence, plot the convergence graph
figure(2)
convX=X(:, 1:i+1);
plot(convX(1,:)); 
hold on 
plot(convX(2,:))
title(['Convergence of the price and quantity using GS ' ]);
legend('Price','Quantity');
xlabel('Iteration');
hold off
end

%% 1.6  Revisiting non convergence using Successive Over-Relaxation  
disp('Revisiting non convergence using Successive Over-Relaxation.  ');
maxit = 100000;
tol=1e-6;
Q = tril(A);
Qinv = inv(Q);
X_1 = zeros(2 , maxit+1); 
X_1(:, 1) = x;
lam_grid = 0.1:0.1:0.9;

for j = 1: size(lam_grid,2)
    x =  x_init;
    lam = lam_grid(j);
    disp(['Trying lambda: ', num2str(lam)])
              for i = 1:maxit
                dx= Qinv * (Z-A*x);
                x = x + lam*dx;
                X_1(:, i+1) = x; 
                    if norm(lam*dx) < tol ,  break, end
                    if i == maxit, disp(['For lamda =', num2str(lam), ' successive over-relaxation does not converge.']), end
              end   
                 num_it_for_lam(j) = i; 
end

[opt_lam_min_inter ,opt_lam_index] = min(num_it_for_lam);
disp(['The lambda for which the smallest number of iteration to converge was needed:  ' , num2str(lam_grid(opt_lam_index))]);
