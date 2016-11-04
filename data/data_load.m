function [handles, filt_id] = data_load(handles)
%LOAD_DATA Summary of this function goes here
%   Detailed explanation goes here

switch handles.data_id
        
    case 'tms + vc'
        try
            [handles.reader, handles.processed] = load_tms_vc(handles.reader);
            delete(handles.panel_graph);
            handles = graphs_tms_vc(handles);
            filt_id = 1;
        catch
            filt_id = 0;
        end
        
    case 'mepanalysis'
        handles.reader = load_mepanalysis(handles.reader);
        
    case 'multi channels'
        try
        [handles.reader, handles.processed] = load_multi(handles.reader);
        
        if isfield(handles, 'panel_graph')
            delete(handles.panel_graph);
            handles = rmfield(handles, 'panel_graph');
            handles = rmfield(handles, 'haxes');
        end
        
        handles = graphs_multi(handles);
        
        filt_id = 1;
        
        catch
            filt_id = 0;
        
        end
end


function [reader, processed] = load_tms_vc(reader)
%LOAD_TMS_VC Summary of this function goes here
%   Detailed explanation goes here

sub_name = reader.sub_name;
leg = reader.leg;
process_id = reader.process_id;

if process_id == 1
    series_nb = reader.series_nb;
    filename = [sub_name '_' leg '_Serie' num2str(series_nb) '.mat'];
elseif process_id == 2
    filename = [sub_name '_' leg '_MVCpre.mat'];
elseif process_id == 3
    filename = [sub_name '_' leg '_MVC2min.mat'];
end

[load_file, load_path, filt_id] = uigetfile({'*.mat','MATLAB File (*.mat)'},...
    'Select the saved processed file', filename);

if filt_id
    data_load = load([load_path load_file]);
    reader = data_load.reader;
    processed = data_load.processed;
    
    if ~isfield(reader, 'process_id')
        reader.process_id = 1;
    end
end

function [reader, processed] = load_multi(reader)
%LOAD_MULTI Summary of this function goes here
%   Detailed explanation goes here

subject = reader.subject;
filename_aux = [subject{1,1} 'data.mat'];

[filename, pathname, filt_id] = uigetfile({'*.mat','MATLAB File (*.mat)'},...
    'Select the saved processed file', filename_aux);

if filt_id
    data_load = load([pathname filename]);
    reader = data_load.reader;
    processed = data_load.processed;
    
end