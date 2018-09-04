function [ ] = ShowbyCode(data,code)
    if(isempty(code)) %no code, show data without color
        plot(data(:,1),data(:,2),'k.');
        axis([-8 8 -8 8]);
        box on; grid on; 
        return;
    end

    %show data, whose color denoting its code
    index = {(code(:,1)==-1)&(code(:,2)==-1),(code(:,1)==-1)&(code(:,2)==1),(code(:,1)==1)&(code(:,2)==-1),(code(:,1)==1)&(code(:,2)==1)};
    indexname = {'code 00','code 01','code 10','code 11'};
    for j = 1:length(index)
       points = data(index{j},:);
       if(isempty(points))
           continue;
       end
        plot(points(:,1),points(:,2),[gen_color(j), '.']);
        hold on;

    end
    box on; grid on;
    axis([-8 8 -8 8]);
    legend_font_size = 12;
    hleg = legend(indexname);
    set(hleg, 'FontSize', legend_font_size);
    set(hleg,'Location', 'northwest');
end


