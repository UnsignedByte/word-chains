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
weights = zeros(keyCount);

for i = 1:length(lines)
    l = lines{i};
    for j = 1:length(l)
        if j==1
            last = '__start__';
        else
            last = l{j-1};
        end
        counts(wordmap(last)) = counts(wordmap(last))+1;
        weights(wordmap(last),wordmap(l{j})) = weights(wordmap(last),wordmap(l{j}))+1;
    end
    
    if mod(i, 500) == 0
        disp(['line ' num2str(i) ' analyzed.']);
    end
end

matrix = cell(1,keyCount);

toc;
for i = 1:keyCount
    items = zeros(1,counts(i));
    k = 1;
    for j = 1:counts(i)
        while weights(i,k) == 0
            k = k+1;
        end
        items(j) = k-1;
        weights(i,k) = weights(i,k)-1;
    end
    matrix{i} = items;
    if mod(i, 10000) == 0
        disp(['word ' num2str(i) ' finalized.']);
    end
end

toc;
disp('Saving...')

fid = fopen('output.json', 'w');

out = struct;
out.words = words;
out.wordmap = wordmap;
out.matrix = matrix;

fprintf(fid, ['var data = ' jsonencode(out)]);
fclose(fid);