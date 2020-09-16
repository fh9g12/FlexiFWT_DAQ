function I = GetConfigIndicies(RunData,filters)
I = true(1,length(RunData));
for i = 1:length(filters)
    if isstr(filters{i}{1})
        if ~isfield(RunData,filters{i}{1})
        
        else
            %if here field exists to filter on           
            % check if field is numeric or a string
            if isstr(RunData(1).(filters{i}{1}))
                data = string({RunData.(filters{i}{1})});
                % if data is a string check filter is a string or a set of cell array of strings
                if isstr(filters{i}{2})
                    I = I & strcmp(data,filters{i}{2});
                % if its a cell of multiple filters filter by all of them
                elseif iscell(filters{i}{2})
                    for j= 1:length(filters{i}{2})
                        if isstr(filters{i}{2}{j})             
                            if j == 1
                                I_temp = strcmp(data,filters{i}{2});  
                            else
                                I_temp = I_temp | strcmp(data,filters{i}{2});       
                            end       
                        end
                    end
                    I = I & I_temp;
                end                                 
            % check if numeric    
            elseif isnumeric(RunData(1).(filters{i}{1}))
                data = [RunData.(filters{i}{1})];
                % if filter numeric filter for each item in array
                if isnumeric(filters{i}{2})
                    filts = filters{i}{2};
                    for j= 1:length(filts)
                        if j == 1
                            I_temp = data == filts(j);         
                        else
                            I_temp = I_temp | data == filts(j);         
                        end                 
                    end
                    I = I & I_temp;
                elseif iscell(filters{i}{2})
                    if strcmp(filters{i}{2}{1},'range')
                        if isnumeric(filters{i}{2}{2}) && length(filters{i}{2}{2}) == 2
                            bounds = filters{i}{2}{2};
                            I = I & (data >= bounds(1) & data <= bounds(2));
                        end
                    end
                end
            end          
        end
        
    end   
end