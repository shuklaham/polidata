function [] = cluster_cons()
    close all;
   
    prompts = {'Please provide cluster array enclosed in square brackets, for ex: [1 2 3]\n';...
        'Please provide name of excel file with extension\n';...
        'Please provide name of sheet from excel file\n';...
        'Please provide table array, for ex: A2:C45\n'};

    clusterarray = input(cell2mat(prompts(1)));
    filename = input(cell2mat(prompts(2)),'s');
    sheetname = input(cell2mat(prompts(3)),'s');
    tableArray = input(cell2mat(prompts(4)),'s');

    data1=xlsread(filename,sheetname,tableArray);

    figure;
    scatter3(data1(:,1),data1(:,2),data1(:,3));
    xlabel('x-axis-BJP'); ylabel('y-axis-AAP');zlabel('z-axis-INC');
    view(83.5,26);
    grid on
    title(filename);
    
    x=data1(:,1);y=data1(:,2);
    figure;
    A = zeros(floor(max(x))+1,floor(max(y)+1));
    for i = 1:length(x)
        A(floor(x(i))+1,floor(y(i))+1) = data1(i,3);
    end
    h=bar3(A);

    for k = 1:numel(h)
        index = logical(kron(A(:,k) == 0,ones(6,1)));
        zData = get(h(k),'ZData');
        zData(index,:) = nan;
        set(h(k),'ZData',zData);
    end
    xlabel('x-axis-BJP'); ylabel('y-axis-AAP');zlabel('z-axis-INC');
    title(filename);
    view(83.5,26);
    grid on
    
    p=1;
    for i = clusterarray
        [cid,cmeans] = kmeans(data1,i,'dist','sqeuclidean');
        silh= silhouette(data1,cid,'sqeuclidean');
        clustermean(p) = mean(silh);
        p=p+1;
    end

    figure;
    scatter(clusterarray,clustermean,'o','MarkerFaceColor','b')
    xlabel('No of Clusters'); ylabel('Cluster Mean');
    title(filename);
    
    for k = clusterarray

        [cid,cmeans] = kmeans(data1,k,'dist','sqeuclidean');
        %   subplot(1,2,2);
        figure;
        [silh,h] = silhouette(data1,cid,'sqeuclidean');

        ptsymbcol = {'m','r','b','g','k','c', [0.9100    0.4100    0.1700]};

        figure;

        for i = 1:k
            clust = find(cid==i);
            plot3(data1(clust,1),data1(clust,2),data1(clust,3),'o','MarkerFaceColor',ptsymbcol{i});
            hold on
        end


        hold off
        xlabel('x-axis BJP'); ylabel('y axis AAP');zlabel('z axis INC');
        view(83.5,26);
        grid on
        title([filename,' Number of clusters ', num2str(k)]);
    end 
   

end


