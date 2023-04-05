function ethernetHubMask(block, stations)

comblk = [block '/Combine'];
swblk = [block '/Replicator'];

% Delete existing From, Goto blocks and lines
froms = find_system(block, 'FollowLinks', 'on', 'LookUnderMasks', 'all', 'SearchDepth', 1, 'BlockType', 'From');
gotos = find_system(block, 'FollowLinks', 'on', 'LookUnderMasks', 'all', 'SearchDepth', 1, 'BlockType', 'Goto');

for i = 1:length(froms)    
    b = froms{i};
    lhs = get_param(b, 'LineHandles');
    line = lhs(1).Outport(1);
    delete_line(line);
    delete_block(b);
end

for i = 1:length(gotos)
    b = gotos{i};
    lhs = get_param(b, 'LineHandles');
    line = lhs.Inport(1);
    delete_line(line);
    delete_block(b);
end

% Re-configure according to new parameter values
n = length(stations);
set_param(comblk, 'NumberInputPorts', num2str(n));
set_param(swblk, 'NumberReplicas', num2str(n-1));
for i = 1:n
    id = stations(i);
    
    f = [block '/From' num2str(i)];    
    add_block('built-in/From', f);
    set_param(f, 'GotoTag', ['tx' num2str(id)]);
    set_param(f, 'Position', [100 (60+i*20) 140 (73+i*20)]);
    set_param(f, 'ShowName', 'off');
    add_line(block, ['From' num2str(i) '/1'], ['Combine/' num2str(i)]);    
    
    g = [block '/Goto' num2str(i)];
    add_block('built-in/Goto', g);
    set_param(g, 'GotoTag', ['rx' num2str(id)]);
    set_param(g, 'TagVisibility', 'global');
    set_param(g, 'Position', [420 (60+i*20) 460 (73+i*20)]);
    set_param(g,'ShowName','off');    
    add_line(block, ['Replicator/' num2str(i)], ['Goto' num2str(i) '/1']);
end

end