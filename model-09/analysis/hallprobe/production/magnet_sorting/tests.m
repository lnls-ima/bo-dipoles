
% G = [];
% fn = fieldnames(re);
% for i=1:length(fn)-1
%     G = [G, re.(fn{i}).G];
% end

figure;
% % R = zeros(2,size(G,2));
% % for i=1:size(R,2)
% %     R(:,i) = specifics.calc_residue(G(:,i),opt.objective_data);
% % end
scatter(R(1,:), R(2,:), '.');
hold all;
% 
% R2 = zeros(2,size(G,2));
% for i=1:size(R2,2)
%     R2(:,i) = specifics.calc_residue(G(:,i),opt2.objective_data);
% end
scatter(R2(1,:), R2(2,:), '.');
% 
% R3 = zeros(2,size(G,2));
% for i=1:size(R3,2)
%     R3(:,i) = specifics.calc_residue(G(:,i),opt3.objective_data);
% end
scatter(R3(1,:), R3(2,:), '.');
% 
% R4 = zeros(2,size(G,2));
% for i=1:size(R4,2)
%     R4(:,i) = specifics.calc_residue(G(:,i),opt4.objective_data);
% end
scatter(R4(1,:), R4(2,:), '.');
% 
% R0 = zeros(2,size(G,2));
% for i=1:size(R0,2)
%     R0(:,i) = specifics.calc_residue(G(:,i),opt3.objective_data);
% end
scatter(R0(1,:), R0(2,:), '.');

figure;
plot(sqrt(diag(R'*R)));
hold all;
plot(sqrt(diag(R2'*R2)));
plot(sqrt(diag(R3'*R3)));
plot(sqrt(diag(R4'*R4)));
plot(sqrt(diag(R0'*R0)));