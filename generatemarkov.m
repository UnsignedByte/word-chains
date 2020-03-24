tic;
lines = cellfun(@split, splitlines(fileread('Plaintext-Data/compiledraw.txt')), 'UniformOutput', false);

words = {'__start__'};
wordmap = containers.Map('KeyType', 'char', 'ValueType', 'uint32');
wordmap('__start__') = 0;

keyCount = 1;

for i = 1:length(lines)
    l = lines{i};
    for j = 1:length(l)
        if isempty(l{j}) %ignore empty words
            continue;
        end
        if ~isKey(wordmap, l{j})
            keyCount = keyCount + 1;
            words{keyCount} = l{j};
            wordmap(l{j}) = keyCount-1;
        end
    end
    
    if mod(i, 5000) == 0
        disp(['line ' num2str(i) ' initiated.']);
    end
end

toc;

counts = zeros(1,keyCount); % Measures number of times this word precedes another word
% usecounts = zeros(1, keyCount); %number of times this word follows another word
weights = zeros(keyCount);

for i = 1:length(lines)
    l = lines{i};
    last = '__start__';
    for j = 1:length(l)
        if isempty(l{j}) %ignore empty words
            continue;
        end
%         usecounts(wordmap(l{j})+1) = usecounts(wordmap(l{j})+1)+1;
        counts(wordmap(last)+1) = counts(wordmap(last)+1)+1;
        weights(wordmap(last)+1,wordmap(l{j})+1) = weights(wordmap(last)+1,wordmap(l{j})+1)+1;
        last = l{j};
    end
    
    % map punctuation to __start__
%     usecounts(wordmap('__start__')+1) = usecounts(wordmap('__start__')+1)+1;
    if ~isempty(l{j}) %ignore empty words
        counts(wordmap(l{j})+1) = counts(wordmap(l{j})+1)+1;
        weights(wordmap(l{j})+1,wordmap('__start__')+1) = weights(wordmap(l{j})+1,wordmap('__start__')+1)+1;
    end
    
    if mod(i, 1000) == 0
        disp(['line ' num2str(i) ' analyzed.']);
    end
end
toc;

%% generate markov chain of 100 most used words/punctuation

% [~,inds] = maxk(usecounts,100);
% markovmat = zeros(length(inds)+1);
% markovmat(1:end-1, 1:end-1) = weights(inds,inds);
% markovmat(end,1:end-1) = sum(weights(setdiff(1:end,inds),inds), 1); %from other to top 100
% markovmat(1:end-1,end) = sum(weights(inds,setdiff(1:end,inds)), 2); %from top 100 to other
% markovmat(end,end) = sum(weights(setdiff(1:end,inds),setdiff(1:end,inds)), 'all'); %from other to other
% markovmat = diag(1./sum(markovmat,2))*markovmat;
% nodenames = cell(1,size(markovmat,1));
% nodenames(1:end-1) = arrayfun(@(x) words(x), inds);
% nodenames{end} = 'Other Words';
% nodenames{strcmp('__start__', nodenames)} = 'Sentence Start'; %replace __start__ with appropriate name
% % nodenames = convertCharsToStrings(nodenames); %convert to string array
% transitionmatrix = digraph(markovmat, nodenames);
% %custom colormap
% cmap = [0.278431385755539,0.137254908680916,0.909803926944733;0.277825087308884,0.146424025297165,0.912649035453796;0.277218818664551,0.155593156814575,0.915494143962860;0.276612520217896,0.164762273430824,0.918339252471924;0.274566322565079,0.195708066225052,0.927941501140595;0.272520095109940,0.226653844118118,0.937543749809265;0.270473897457123,0.257599622011185,0.947145938873291;0.268427670001984,0.288545429706574,0.956748187541962;0.266381472349167,0.319491207599640,0.966350436210632;0.264335274696350,0.350436985492706,0.975952625274658;0.262289047241211,0.381382793188095,0.985554873943329;0.260242849588394,0.412328571081162,0.995157122612000;0.247171416878700,0.434890478849411,0.986687719821930;0.234099999070168,0.457452386617661,0.978218376636505;0.221028566360474,0.480014294385910,0.969748973846436;0.207957133650780,0.502576172351837,0.961279571056366;0.194885700941086,0.525138080120087,0.952810168266296;0.181814283132553,0.547699987888336,0.944340825080872;0.168742850422859,0.570261895656586,0.935871422290802;0.179427549242973,0.584017038345337,0.879669189453125;0.190112248063087,0.597772240638733,0.823467016220093;0.200796946883202,0.611527383327484,0.767264783382416;0.211481645703316,0.625282526016235,0.711062550544739;0.222166344523430,0.639037668704987,0.654860377311707;0.232851028442383,0.652792870998383,0.598658144474030;0.243535727262497,0.666548013687134,0.542455911636353;0.254220426082611,0.680303156375885,0.486253708600998;0.264905124902725,0.694058299064636,0.430051505565643;0.275589823722839,0.707813501358032,0.373849272727966;0.286274522542954,0.721568644046783,0.317647069692612;0.324788719415665,0.740320861339569,0.316017091274262;0.363302916288376,0.759073078632355,0.314387083053589;0.401817113161087,0.777825355529785,0.312757104635239;0.440331310033798,0.796577572822571,0.311127126216888;0.478845477104187,0.815329790115356,0.309497117996216;0.517359673976898,0.834082007408142,0.307867139577866;0.555873870849609,0.852834224700928,0.306237161159515;0.594388067722321,0.871586501598358,0.304607182741165;0.632902264595032,0.890338718891144,0.302977174520493;0.671416461467743,0.909090936183929,0.301347196102142;0.718356966972351,0.922077953815460,0.267821401357651;0.765297472476959,0.935064971446991,0.234295621514320;0.812237977981567,0.948051989078522,0.200769826769829;0.859178483486176,0.961038947105408,0.167244032025337;0.906118988990784,0.974025964736939,0.133718252182007;0.953059494495392,0.987012982368469,0.100192457437515;1,1,0.0666666701436043;0.993464052677155,0.942047953605652,0.0675381273031235;0.986928105354309,0.884095847606659,0.0684095919132233;0.980392158031464,0.826143801212311,0.0692810490727425;0.973856210708618,0.768191695213318,0.0701525062322617;0.967320263385773,0.710239648818970,0.0710239708423615;0.960784316062927,0.652287602424622,0.0718954280018807;0.954248368740082,0.594335496425629,0.0727668851613998;0.947712421417236,0.536383450031281,0.0736383497714996;0.941176474094391,0.478431373834610,0.0745098069310188;0.948529422283173,0.418627440929413,0.0651960819959641;0.955882370471954,0.358823537826538,0.0558823570609093;0.963235318660736,0.299019604921341,0.0465686284005642;0.970588207244873,0.239215686917305,0.0372549034655094;0.977941155433655,0.179411768913269,0.0279411785304546;0.985294103622437,0.119607843458653,0.0186274517327547;0.992647051811218,0.0598039217293263,0.00931372586637735;1,0,0];
% hold on
%     f = figure('visible', 'off');
%     colormap(cmap)
%     p = plot(transitionmatrix);
%     [~,x] = sort(transitionmatrix.Edges.Weight);
%     [~, colors] = sort(x); 
%     colors = colors./numel(colors);
%     p.EdgeCData = colors;
%     p.NodeLabel = nodenames;
% hold off
% 
% disp('Finished top 100');
% toc;


%% Generate wordmatrix
matrix = cell(1,keyCount);
wusecount = weights;

for i = 1:keyCount
    items = zeros(1,counts(i));
    k = 1;
    for j = 1:counts(i)
        while wusecount(i,k) == 0
            k = k+1;
        end
        items(j) = k-1;
        wusecount(i,k) = wusecount(i,k)-1;
    end
    matrix{i} = items;
    if mod(i, 10000) == 0
        disp(['word ' num2str(i) ' finalized.']);
    end
end

toc;
disp('Generating markov chain transition matrix');
[~,inds] = maxk(counts,min(2000,keyCount)); %take most used k words
markovmat = zeros(length(inds)+1);
markovmat(1:end-1, 1:end-1) = weights(inds,inds);
markovmat(end,1:end-1) = counts(inds)-sum(markovmat(1:end-1,1:end-1),1); %from other to top 100
markovmat(1:end-1,end) = counts(inds)'-sum(markovmat(1:end-1,1:end-1),2); %from top 100 to other
rsums = [counts(inds) sum(counts(setdiff(1:end,inds)))];
markovmat(end,end) = rsums(end)-sum(markovmat(1:end-1,end)); %from other to other
% markovmat = diag(1./sum(markovmat,2))*markovmat;
markovmat = diag(1./rsums)*markovmat;

toc;
disp('Naming Nodes');
nodenames = cell(size(markovmat,1),1);
nodenames(1:end-1) = arrayfun(@(x) words(x), inds); %get names of top 10k
nodenames{end} = 'Other Words';
nodenames{strcmp('__start__', nodenames)} = 'Sentence Start'; %replace __start__ with appropriate name
toc;
disp('Generating named cell');
transitionmatrix = cell(length(inds)+2);
transitionmatrix(2:end,2:end) = num2cell(markovmat);
transitionmatrix(2:end,1) = nodenames;
transitionmatrix(1,2:end) = nodenames;
% transitionmatrix = array2table(markovmat, 'VariableNames', nodenames, 'RowNames', nodenames);
% convert to named table

toc;
disp('Saving matrix');
writecell(transitionmatrix, 'transitionmatrix.csv')

toc;
disp('Saving json')

fid = fopen('output.js', 'w');

out = struct;
out.words = words;
out.wordmap = wordmap;
out.matrix = matrix;

fprintf(fid, ['var data = ' jsonencode(out)]);
fclose(fid);