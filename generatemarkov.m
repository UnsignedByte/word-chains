tic;
lines = cellfun(@split, splitlines(fileread('Plaintext-Data/compiledraw.txt')), 'UniformOutput', false);

words = {'__start__'};
wordmap = containers.Map('KeyType', 'char', 'ValueType', 'uint32');
wordmap('__start__') = 1;

keyCount = 1;

for i = 1:length(lines)
    l = lines{i};
    for j = 1:length(l)
        if ~isKey(wordmap, l{j})
            keyCount = keyCount + 1;
            words{keyCount} = l{j};
            wordmap(l{j}) = keyCount;
        end
    end
    
    if mod(i, 1000) == 0
        disp(['line ' num2str(i) ' initiated.']);
    end
end

toc;

counts = zeros(1,keyCount);
matrix = zeros(keyCount);

for i = 1:length(lines)
    l = lines{i};
    for j = 1:length(l)
        if j==1
            last = '__start__';
        else
            last = l{j-1};
        end
        counts(wordmap(last)) = counts(wordmap(last))+1;
        matrix(wordmap(last),wordmap(l{j})) = matrix(wordmap(last),wordmap(l{j}))+1;
    end
    
    if mod(i, 500) == 0
        disp(['line ' num2str(i) ' analyzed.']);
    end
end

toc;
for i = 1:keyCount
    matrix(i,:) = matrix(i,:)/counts(i);
    if mod(i, 1000) == 0
        disp(['word ' words{i} ' finalized.']);
    end
end

toc;
disp('Saving...')

fid = fopen('output.json', 'w');

out = struct;
out.words = words;
out.wordmap = wordmap;
out.matrix = matrix;

fprintf(fid, jsonencode(out));
fclose(fid);