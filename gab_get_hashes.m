function task=gab_get_hashes(task)
%Function to find all of the md5 hashes of the functions that will be used
%by a task, and output them in the '.funcHashes' field
%
%Only the top level functions are checked to prevent it from taking an hour
%to run

func_list=depfun(which(func2str(task.func)),'-toponly','-quiet');

task.funcHashes=struct('funcName',[],'md5',[]);

for f=1:length(func_list)
    [path,file]=fileparts(func_list{f});
    
    task.funcHashes(f).funcName=file;
    
    [err,outp]=unix(['md5sum ' func_list{f}]);
    if err
        error(['Tried to get hash for unknown function: ' func_list{f}]);
    end
    task.funcHashes(f).md5=outp(1:32); %the hash is the first 32 characters of the output
end