function ethernetStationMask(block, id)

f = [block '/From'];
set_param(f, 'GotoTag', ['rx' num2str(id)]);

g = [block '/Goto'];
set_param(g, 'GotoTag', ['tx' num2str(id)]);

end